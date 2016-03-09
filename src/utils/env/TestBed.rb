# This class defines a test bed containing nodes, and has methods to retrieve node details and initializing SSH connections.

require "test/unit"
require 'getoptlong'
require 'yaml'
require "net/ssh"

require_relative "../core/Constants.rb"
require_relative "Node.rb"
require "base64"

class TestBed 
  
  def initialize (env_path, environment)
    @nodes = YAML::load_file(env_path + "/" + environment + "/nodes.yml")
    @config = YAML::load_file(env_path + "/" + environment + "/" + "/config.yml")  
  end
  
  # Returns a list of nodes of a given type from a given environment
  def get_nodes(type)
    threads = []
    nodes = Array.new
    index = 0
    @nodes[type].each do |x|
      node = getNode(type, index + 1)
      threads[index] = Thread.new{
        node.password = get_pass(node.password)
        node.handle = single_handle(node.ip, node.username, node.password)
        nodes.push(node)
      }
      index += 1
    end
    threads.each do |t|
      t.join
    end
    puts "Returning nodes"
    return nodes
  end
  
  # Initiates an SSH session to a given server
  def single_handle(ip, username, password)
     return Net::SSH.start(ip, username, :password => password, :auth_methods => ["password", "publickey"], :paranoid => false, :forward_agent => true)
  end
  
  # Returns the chat application token defined in the configuration file
  def get_token
    return @config["HIPCHAT_TOKEN"]
  end
  
  # Returns the chat application room name defined in the configuration file
  def get_room
    return @config["ROOM"]
  end
  
  # Returns the password after decoding it from the configuration file
  def get_pass(password)
    return Base64.decode64(password)
  end
  
  # Returns a node given its index from a list of nodes
  def getNode(type, index)
    nodes = @nodes[type]
    k = nodes.keys
    reqdNode = nodes[k[index-1]]
    return hashToNode(k[index-1], reqdNode)
  end
  
  # Creates a node object from the node hash passed to it
  def hashToNode(name, nodeHsh)
    node = Node.new()
    node.name=(name)
    node.ip=(nodeHsh["ip"])
    node.username=(nodeHsh["username"])
    node.password=(nodeHsh["password"])
    node.type=(nodeHsh["type"])
    return node
  end
   
end