# Defines methods for operations possible on a MongoDB cluster

require 'fileutils'
require 'csv'
require 'json'
require 'yaml'
require "net/ssh"

class Mongo
  
  def mongod_restart(node)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' service mongod restart")
  end
   
  def cluster_restart(nodes)
    threads = []
    index = 0
    nodes.each do |node|
      threads[index] = Thread.new(node){
        node.handle.exec!("echo #{node.password} | sudo -S -p '' service mongod restart")
      }
      index += 1
    end
    threads.each do |t|
      t.join
    end
  end
  
  def mongod_stop(node)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' service mongod stop")
  end
   
  def cluster_stop(nodes)
    threads = []
    index = 0
    nodes.each do |node|
      threads[index] = Thread.new(node){
        node.handle.exec!("echo #{node.password} | sudo -S -p '' service mongod stop")
      }
      index += 1
    end
    threads.each do |t|
      t.join
    end
  end

  def mongod_start(node)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' service mongod start")
  end
   
  def cluster_start(nodes)
    threads = []
    index = 0
    nodes.each do |node|
      threads[index] = Thread.new(node){
        node.handle.exec!("echo #{node.password} | sudo -S -p '' service mongod start")
      }
      index += 1
    end
    threads.each do |t|
      t.join
    end
  end
   
end