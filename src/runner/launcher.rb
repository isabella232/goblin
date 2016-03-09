# Class that initiates the collection and running of required test cases

require 'getoptlong'

require_relative 'runner.rb'
require_relative 'collector.rb'

opts = GetoptLong.new(
  [ '--help', GetoptLong::NO_ARGUMENT ],
  [ '--files',GetoptLong::REQUIRED_ARGUMENT],
  [ '--group', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--config', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--env', GetoptLong::OPTIONAL_ARGUMENT ]
  )


opts.each do |opt, arg|
    case opt
    when '--help'
      puts <<-EOF
      --files:
          List of test files or file path to be executed. ex:--files='test.rb',~/tests/*.rb
      --group:
          List of test sets to be executed . ex:--group='sanity','fvt'  
      --config:
          Specify the test config yml file you want to access as hash variable,this can be accessed as $test_config . ex :--config='config.yml'
      --env:
          Specify the test environment variable,this can be accessed as $env. ex : --env='production'
      EOF
      exit
    when '--files'
      $files=arg.gsub(/\s+/, "").split(",").map!{ |val| val }
    when '--group'
      $group = arg.gsub(/\s+/, "").split(",").map!{ |val| val }
    when '--config'
      $config = arg.to_s
    when '--env'
      $env=arg.to_s
    end

 end

#current path
current_path=File.expand_path(File.dirname(__FILE__))

#collector logic
collector=Collector.new
test_collection=collector.collect($files)

#runner logic
runner=Runner.new
if $config
	runner.load_config($config)
end

#generate report
report=runner.run(test_collection,$group)
puts "Find results in goblin_report yml file"

#report file path
t=Time.now.to_i
report_file="goblin_report_"+t.to_s+".yml"
file_path=File.join(current_path,report_file)

#dump file
File.open(file_path, "wb") do |out|
      YAML.dump(report.to_yaml, out)
end
