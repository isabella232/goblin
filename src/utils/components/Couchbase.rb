# Defines methods for operations possible on a Couchbase cluster

require 'fileutils'
require 'csv'
require 'json'
require 'yaml'
require "net/ssh"

class Couchbase
  
  def cb_server_restart(node)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' service couchbase-server restart")
  end
   
  def cluster_restart(nodes)
    threads = []
    index = 0
    nodes.each do |node|
      threads[index] = Thread.new(node){
        node.handle.exec!("echo #{node.password} | sudo -S -p '' service couchbase-server restart")
      }
      index += 1
    end
    threads.each do |t|
      t.join
    end
  end
  
  def cb_server_stop(node)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' service couchbase-server stop")
  end
   
  def cluster_stop(nodes)
    threads = []
    index = 0
    nodes.each do |node|
      threads[index] = Thread.new(node){
        node.handle.exec!("echo #{node.password} | sudo -S -p '' service couchbase-server stop")
      }
      index += 1
    end
    threads.each do |t|
      t.join
    end
  end

  def cb_server_start(node)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' service couchbase-server start")
  end
   
  def cluster_start(nodes)
    threads = []
    index = 0
    nodes.each do |node|
      threads[index] = Thread.new(node){
        node.handle.exec!("echo #{node.password} | sudo -S -p '' service couchbase-server start")
      }
      index += 1
    end
    threads.each do |t|
      t.join
    end
  end
   
end