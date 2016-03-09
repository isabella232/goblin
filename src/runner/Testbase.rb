# Base class that defines abstract mandatory functions required to be implemented by derived Test classes

class Testbase 
  
  def pretest_setup
    raise "pretest_setup: must be implemented by a class"
  end
  
  def posttest_cleanup
      raise "posttest_cleanup: must be implemented by a class"
  end
  
  def generate_load
    raise "generate_load: must be implemented by a class"
  end

  def fail(error)
    @fail=error
    raise "stopping the execution, test failed due to test case failure  #{error}"
  end

  class Test

    def test_setup
    end

    def simulate_failure
      raise "simulate_failure: must be implemented by a class"
    end

    def validate
      raise "validate: must be implemented by a class"
    end
    
    def recover
      raise "recover: must be implemented by a class"
    end

    def fail(error)
      @fail=error
      raise "stopping the execution, test failed due to test case failure #{error}"
    end
    
    def test_cleanup
    end

  end

end
