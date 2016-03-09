# Class that defines the execution of each test in a generic manner

require 'yaml'
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
            execution_time=(Time.now-@class_start_time).to_i
            @class_start_time=nil
        else
            if start_time
                execution_time=(Time.now-start_time).to_i
            else
                execution_time=0
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


end