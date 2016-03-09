# Defines a set of constants like directory paths that are repeatedly used within the framework

class Constants
  attr_reader :SCRIPT_PATH
  attr_reader :ENV_PATH

  def initialize
    @ENV_PATH = File.absolute_path("../../../resources/environments", Dir.getwd)
    @SCRIPT_PATH = File.absolute_path("../../../resources/environments", Dir.getwd)
  end
end