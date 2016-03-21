# Class that defines the execution of each test in a generic manner

require 'yaml'
require 'nokogiri'

require_relative 'Testbase.rb'

class Runner

  @@report=Hash.new
  #Collect excution test cases
  def get_execution_set(collect_hash,group)
    if group
      execution_cases=Hash.new
      collect_hash.each do |resclass,testcases|
        tests=[]
        for test in testcases
          for i in group
            if test.constants.include?(:GROUP) and test::GROUP.include?i
              tests.push(test)
              break
            end
          end
        end
        if not tests.empty?
          execution_cases[resclass]=tests
        end
      end
      return execution_cases
    else
      return collect_hash
    end
  end

  #excute cases
  def execute_set(test_set)
    test_set.each do |resclass,testcases|
      begin
        @class_start_time=Time.now
        rescase=resclass.new
        rescase.pretest_setup
        rescase.generate_load
        for i in  testcases
          #check_set(i,group)
          begin
            start_time=Time.now
            testcase=i.new
            testcase.test_setup
            testcase.simulate_failure
            testcase.validate
            testcase.recover
            reason='NA'
            btrace='NA'
            status='pass'
          rescue Exception => e
            btrace=e.backtrace.inspect
            failed=testcase.instance_variable_get(:@fail)
            if failed
              puts "Test failed,#{failed}"
              status='fail'
              reason=failed
            else
              puts "Test case failed, Error: #{e}"
              status='error'
              reason=e
            end
          end

          begin
            testcase.test_cleanup
          rescue Exception => e
            puts "Test case cleanup failed,execution continued "
          end

          report_collector(resclass,i,status,reason,start_time,btrace)

        end

      rescue Exception => e
        btrace=e.backtrace.inspect
        failed=rescase.instance_variable_get(:@fail)
        if failed
          puts "Test Class execution failed , #{failed} ,"
          status='fail'
          reason=failed
        else
          puts "Test Class execution failed, Error: #{e}"
          status='skipped'
          reason=e
        end
        for i in testcases
          report_collector(resclass,i,status,"Class_Error: #{reason}",nil,btrace)
        end
      end

      begin
        rescase.posttest_cleanup
      rescue Exception => e
        puts "Test class cleanup failed, execution continued."
      end
    end
  end

  #report collector
  def report_collector(resclass,testcase,status,reason,start_time,btrace)
    if @class_start_time
      execution_time=(Time.now-@class_start_time).round(2)
      @class_start_time=nil
    else
      if start_time
        execution_time=(Time.now-start_time).round(2)
      else
        execution_time=0.00
        btrace='NA'
      end
    end

    result={ "class" => resclass.to_s , "testcase" => testcase.to_s , "status" => status.to_s , "reason" => reason.to_s ,"time" => execution_time ,"backtrace"=>btrace }
    @@report[testcase.to_s]=result
  end

  #test runner
  def run(collect_hash,group)
    test_sets=get_execution_set(collect_hash,group)
    execute_set(test_sets)
    return @@report
  end

  #Load config for user
  def load_config(config_file)
    begin
      $test_config=YAML::load(YAML::load_file(config_file))
    rescue Exception => e
      puts "Error: #{e} while loading the configuration file, please specify valid yaml file"
    end
  end

  def generate_report(result)
      skipped=0
      passed=0
      failed=0 
      time=0
      for k,v in result
          if result[k]['status']=='pass'
              passed += 1
          elsif result[k]['status']=='fail' or result[k]['status']=='error'
              failed += 1
          elsif result[k]['status']=='skipped'
              skipped += 1
          else
              puts "skipping the result,malformed status"
          end
          time += result[k]['time']
      end

      return passed,failed,skipped,time

  end

  def generate_junit_xml(result)
      passed,failed,skipped,time=generate_report(result)
      total=passed+skipped+failed
      suite=Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
          xml.testsuite(:failures=>failed ,:name=>"Goblin Test results" ,:skipped=>skipped ,:tests=>total,:time=>time){
              for k,v in result
                  testcase= result[k]['testcase'].split('::')[-1]
                  if result[k]['status']=="pass"
                      xml.testcase(:classname=>result[k]['class'] ,:name=>testcase,:time=>result[k]["time"]){
                          xml.send (:"system-out"){ 
                              xml.cdata "Passed"
                          }
                      }
                  elsif result[k]['status']=="fail" or result[k]['status']=='error'
                      xml.testcase(:classname=>result[k]['class'] ,:name=>testcase,:time=>result[k]["time"]){
                          xml.failure(:message=>result[k]['backtrace'][0]){
                              xml.cdata result[k]['backtrace']
                          }
                      }
                  elsif result[k]['status']=='skipped'
                      xml.testcase(:classname=>result[k]['class'] ,:name=>testcase,:time=>result[k]["time"]){
                          xml.send(:"skipped")
                      }
                  else
                      puts "skipping"
                  end   
              end 
          }
      end
      return suite.to_xml
  end


end
