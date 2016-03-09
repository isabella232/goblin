
require_relative "../../runner/Testbase.rb"
require_relative "../../utils/core/Constants.rb"
require_relative "../../utils/components/Zookeeper.rb"
require_relative "../../utils/components/Couchbase.rb"

require_relative "../../utils/env/TestBed.rb"
require_relative "../../utils/chat_tools/HipChat.rb"

# ruby launcher.rb [../**/*.rb] [test-group] [test-group] [yml config which will be loaded to a hash]
# ruby launcher.rb --files='../../src/tests/examples/TestZookeeperSample.rb'

class SampleTest1 < Testbase

  def pretest_setup
    puts "inside setup"
    
    currentDir = File.dirname(File.expand_path(__FILE__)) 
    puts currentDir
    Dir.chdir(currentDir)    
    $constants = Constants.new
    puts $constants.inspect
    $env_path = $constants.ENV_PATH
    $testBed = TestBed.new($env_path, $env)
    $token = $testBed.get_token
    puts $token
    
    $room = $testBed.get_room
    $hip = HipChat.new($token,$room) 
    $zookeeper = Zookeeper.new  
    
  end

  def posttest_cleanup
    puts "inside cleanup"
  end

  
  def generate_load
      puts "inside generate_load"
  end

  class Test1 < Testbase::Test
    GROUP=['sanity']
    
    def recover
      puts "inside recover T1"
    end

    def simulate_failure
      puts "inside simulate_failure T1"
      $nodes = $testBed.get_nodes("ZK")
      $zookeeper.exhibitor_node_stop($nodes[0])
    end
      
    def validate
      puts "inside validate - before assert T1"
      #fail("FAIL..... HEheh...!!!")
      #assert(1==2,"failed")
      puts "inside validate - after assert"

    end
  end

  class Test2 < Testbase::Test
    GROUP=['sanity','regress']
    
    def recover
      puts "inside recover T2"
    end

    def simulate_failure
      puts "inside simulate_failure T2"
      $nodes = $testBed.get_nodes("ZK")
      $zookeeper.exhibitor_node_start($nodes[0])
    end
      
    def validate
      puts "inside validate - before assert T2"
      #assert(1==2,"failed")
      puts "inside validate - after assert T2"
    end

  end 
  
end

class SampleTest2 < Testbase


  def pretest_setup
    puts "inside cleanup SampleTest2"
    currentDir = File.dirname(File.expand_path(__FILE__))
    Dir.chdir(currentDir)          
        
    $constants = Constants.new
    $env_path = $constants.ENV_PATH
    @testBed = TestBed.new($env_path, $environment)  
          
    $token = @testBed.get_token
    $room = @testBed.get_room
    $hip = HipChat.new($token,$room)   
           
    @couchbase = Couchbase.new  
  end

  def posttest_cleanup
    puts "inside cleanup SampleTest2"
  end

  
  def generate_load
      puts "inside generate_load SampleTest2"
  end

  class Test1 < Testbase::Test
    GROUP =['sanity','regression']
    def group
      return ["sanity","regression"]
    end

    def recover
      puts "inside recover"
      #fail('HOOOOOO')
      #raise "YYAAAA"
    end

    def simulate_failure
      puts "inside simulate_failure"
      @couchbase.cluster_restart(@testBed.get_nodes("CB"))
    end
      
    def validate
      puts "inside validate - before assert"
      #assert(1==2,"failed")
      puts "inside validate - after assert"
    end
  end   
end
