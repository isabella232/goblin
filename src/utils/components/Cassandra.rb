# Defines methods for operations possible on a Cassandra cluster

require 'fileutils'
require 'csv'
require 'json'
require 'yaml'
require "net/ssh"

class Cassandra
  
  def dse_restart(node)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' service dse restart")
  end
   
  def cluster_restart(nodes)
    threads = []
    index = 0
    nodes.each do |node|
      threads[index] = Thread.new(node){
        node.handle.exec!("echo #{node.password} | sudo -S -p '' service dse restart")
      }
      index += 1
    end
    threads.each do |t|
      t.join
    end
  end
  
  def dse_stop(node)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' service dse stop")
  end
   
  def cluster_stop(nodes)
    threads = []
    index = 0
    nodes.each do |node|
      threads[index] = Thread.new(node){
        node.handle.exec!("echo #{node.password} | sudo -S -p '' service dse stop")
      }
      index += 1
    end
    threads.each do |t|
      t.join
    end
  end

  def dse_start(node)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' service dse start")
  end
   
  def cluster_start(nodes)
    threads = []
    index = 0
    nodes.each do |node|
      threads[index] = Thread.new(node){
        node.handle.exec!("echo #{node.password} | sudo -S -p '' service dse start")
      }
      index += 1
    end
    threads.each do |t|
      t.join
    end
  end
   
end