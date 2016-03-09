# Defines methods for operations possible on a MongoDB cluster

require 'fileutils'
require 'csv'
require 'json'
require 'yaml'
require "net/ssh"

class Mongo
  
  def node_restart(node)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' service mongodb restart")
  end
   
  def cluster_restart(nodes)
    nodes.each do |node|
      Thread.new(node){
        node.handle.exec!("echo #{node.password} | sudo -S -p '' service mongodb restart")
      }
    end
  end
  
  def node_stop(node)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' service mongodb stop")
  end
   
  def cluster_stop(nodes)
    nodes.each do |node|
      Thread.new(node){
        node.handle.exec!("echo #{node.password} | sudo -S -p '' service mongodb stop")
      }
    end
  end

  def node_start(node)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' service mongodb start")
  end
   
  def cluster_start(nodes)
    nodes.each do |node|
      Thread.new(node){
        node.handle.exec!("echo #{node.password} | sudo -S -p '' service mongodb start")
      }
    end
  end
   
end