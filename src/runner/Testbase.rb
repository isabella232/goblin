class Testbase 
  
  #class variables
  def pretest_setup
    raise "pretest_setup : must be implemented by a class"
  end
  
  def posttest_cleanup
      raise "posttest_cleanup : must be implemented by a class"
  end
  
  def generate_load
    raise "generate_load : must be implemented by a class"
  end

  def fail(error)
    @fail=error
    raise "stopping the execution, test faled due to testcase failure  #{error}"
  end

  class Test
    #Test variable    

    def test_setup
    end

    def simulate_failure
      raise "simulate_failure : must be implemented by a class"
    end

    def validate
      raise "validate : must be implemented by a class"
    end
    
    def recover
      raise "recover : must be implemented by a class"
    end

    def fail(error)
      @fail=error
      raise "stopping the execution, test failed due to testcase failure #{error}"
    end
    
    def test_cleanup
    end

  end

end
