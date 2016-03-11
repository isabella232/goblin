
require_relative "../../runner/Testbase.rb"
require_relative "../../utils/core/Constants.rb"
require_relative "../../utils/components/Zookeeper.rb"
require_relative "../../utils/components/Couchbase.rb"
require_relative "../../utils/core/Actions.rb"

require_relative "../../utils/env/TestBed.rb"
require_relative "../../utils/chat_tools/HipChat.rb"

# ruby launcher.rb [../**/*.rb] [test-group] [--env=''] [yml config which will be loaded to a hash]
# ruby launcher.rb --files='../../src/tests/examples/TestSample.rb' --env='example'

class SampleTest1 < Testbase

  def pretest_setup
    puts "Inside Pre-test Setup Suite 1"
    
    currentDir = File.dirname(File.expand_path(__FILE__)) 
    Dir.chdir(currentDir)    
    $constants = Constants.new
    $env_path = $constants.ENV_PATH
    $testBed = TestBed.new($env_path, $env)
    $token = $testBed.get_token
    
    $room = $testBed.get_room
    $hip = HipChat.new($token,$room) 
    $zookeeper = Zookeeper.new  
    
  end

  def posttest_cleanup
    puts "Inside Post-test Clean up"
  end

  
  def generate_load
      puts "Inside generate_load Suite 1"
  end

  class Test1 < Testbase::Test
    GROUP=['sanity']
    
    def recover
      puts "Inside Recover Test1"
    end

    def simulate_failure
      puts "Inside simulate_failure Test1"
      
      # obtain the node ssh handles
      $nodes = $testBed.get_nodes("ZK")
      
      # use the Zookeeper library function to stop the exhibitor process on first node
      $zookeeper.exhibitor_stop($nodes[0])
    end
      
    def validate
      puts "Inside validate - before assert Test1"
      #fail("FAIL..... HEheh...!!!")
      #assert(1==2,"failed")
      puts "Inside validate - after assert Test1"

    end
  end

  class Test2 < Testbase::Test
    GROUP=['sanity','regress']
    
    def recover
      puts "Inside Recover Test2"
    end

    def simulate_failure
      puts "Inside simulate_failure Test2"
      
      # obtain the node ssh handles
      $nodes = $testBed.get_nodes("ZK")
      
      # use the Zookeeper library function to restart the exhibitor process on first node
      $zookeeper.exhibitor_restart($nodes[1])
    end
      
    def validate
      puts "Inside validate - before assert Test2"
      #assert(1==2,"failed")
      puts "Inside validate - after assert Test2"
    end

  end 
  
end

class SampleTest2 < Testbase


  def pretest_setup
    puts "Inside Pre-test Cleanup Suite 2"
    currentDir = File.dirname(File.expand_path(__FILE__))
    Dir.chdir(currentDir)          
        
    $constants = Constants.new
    $env_path = $constants.ENV_PATH
    $testBed = TestBed.new($env_path, $env)  
          
    $token = $testBed.get_token
    $room = $testBed.get_room
    $hip = HipChat.new($token,$room)   
           
    $couchbase = Couchbase.new  
    $actions = Actions.new
  end

  def posttest_cleanup
    puts "Inside Post test Cleanup Suite 2"
  end

  
  def generate_load
      puts "Inside generate_load Suite 2"
  end

  class Test1 < Testbase::Test
    GROUP =['sanity','regression']
    def group
      return ["sanity","regression"]
    end

    def recover
      puts "Inside recover Test1"
      #fail('HOOOOOO')
      #raise "YYAAAA"
    end

    def simulate_failure
      puts "Inside simulate_failure Test1"
      
      # get node handles of type Couchbase and restart the cluster
      $couchbase.cluster_restart($testBed.get_nodes("CB"))
    end
      
    def validate
      puts "Inside validate - before assert Test1"
      #assert(1==2,"failed")
      puts "Inside validate - after assert Test1"
    end
  end  
  
  class Test2 < Testbase::Test
    GROUP =['sanity','regression']
    def group
      return ["sanity","regression"]
    end

    def recover
      puts "Inside recover Test2"
      #stop packet loss
      $actions.stop_packet_loss($nodes[0], 'eth0')
      #fail('YUDoThis')
      #assert(1==2,"failed")
    end

    def simulate_failure
      puts "Inside simulate_failure Test1"
      
      # get node handles of type Couchbase
      $nodes = $testBed.get_nodes("CB")
      # introduce 50% packet loss on eth0 interface between CB node1 & 1.2.3.4
      $actions.packet_loss($nodes[0], '1.2.3.4', 50, 'eth0')
    end
      
    def validate
      sleep 20
      puts "Inside validate - before assert Test1"
      #assert(1==2,"failed")
      puts "Inside validate - after assert Test1"
    end
  end  
   
end
