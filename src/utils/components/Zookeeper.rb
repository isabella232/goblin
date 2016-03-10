# Defines methods for operations possible on a Zookeeper cluster

require 'fileutils'
require 'csv'
require 'json'
require 'yaml'
require "net/ssh"

class Zookeeper
  
  def zk_server_restart(node)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' /usr/lib/zookeeper/bin/zkServer.sh restart")
  end
  
  def zk_leader_restart(nodes)
    nodes.each do |node|
      if(node.handle.exec!("echo stat | nc localhost 2181 | grep Mode")).split(" ")[1] == "leader"
         node.handle.exec!("echo #{node.password} | sudo -S -p '' /usr/lib/zookeeper/bin/zkServer.sh restart")
         break
      end
    end
  end
  
  def zk_follower_restart(nodes)
    nodes.each do |node|
      if(node.handle.exec!("echo stat | nc localhost 2181 | grep Mode")).split(" ")[1] == "follower"
         node.handle.exec!("echo #{node.password} | sudo -S -p '' /usr/lib/zookeeper/bin/zkServer.sh restart")
         break
      end
    end
  end

  def zk_cluster_restart(nodes)
    threads = []
    index = 0
    nodes.each do |node|
      threads[index] = Thread.new(node){
        node.handle.exec!("echo #{node.password} | sudo -S -p '' /usr/lib/zookeeper/bin/zkServer.sh restart")
      }
      index += 1
    end
    threads.each do |t|
      t.join
    end
  end
  
  def zk_server_stop(node)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' /usr/lib/zookeeper/bin/zkServer.sh stop")
  end
  
  def zk_leader_stop(nodes)
    nodes.each do |node|
      if(node.handle.exec!("echo stat | nc localhost 2181 | grep Mode")).split(" ")[1] == "leader"
         node.handle.exec!("echo #{node.password} | sudo -S -p '' /usr/lib/zookeeper/bin/zkServer.sh stop")
         break
      end
    end
  end

  def zk_follower_stop(nodes)
    nodes.each do |node|
      if(node.handle.exec!("echo stat | nc localhost 2181 | grep Mode")).split(" ")[1] == "follower"
         node.handle.exec!("echo #{node.password} | sudo -S -p '' /usr/lib/zookeeper/bin/zkServer.sh stop")
         break
      end
    end
  end
 
  def zk_cluster_stop(nodes)
    threads = []
    index = 0
    nodes.each do |node|
      threads[index] = Thread.new(node){
        node.handle.exec!("echo #{node.password} | sudo -S -p '' /usr/lib/zookeeper/bin/zkServer.sh stop")
      }
      index += 1
    end
    threads.each do |t|
      t.join
    end
  end
  
  def zk_server_start(node)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' /usr/lib/zookeeper/bin/zkServer.sh start")
  end
  
  def zk_cluster_start(nodes)
    threads = []
    index = 0
    nodes.each do |node|
      threads[index] = Thread.new(node){
        node.handle.exec!("echo #{node.password} | sudo -S -p '' /usr/lib/zookeeper/bin/zkServer.sh start")
      }
      index += 1
    end
    threads.each do |t|
      t.join
    end
  end
  
  def exhibitor_restart(node)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' sv restart exhibitor")
  end
  
  def exhibitor_leader_restart(nodes)
    nodes.each do |node|
      if(node.handle.exec!("echo stat | nc localhost 2181 | grep Mode")).split(" ")[1] == "leader"
         node.handle.exec!("echo #{node.password} | sudo -S -p '' sv restart exhibitor")
         break
      end
    end
  end
  
  def exhibitor_follower_restart(nodes)
    nodes.each do |node|
      if(node.handle.exec!("echo stat | nc localhost 2181 | grep Mode")).split(" ")[1] == "follower"
         node.handle.exec!("echo #{node.password} | sudo -S -p '' sv restart exhibitor")
         break
      end
    end
  end
  
  def exhibitor_cluster_restart(nodes)
    threads = []
    index = 0
    nodes.each do |node|
      threads[index] = Thread.new(node){
      node.handle.exec!("echo #{node.password} | sudo -S -p '' sv restart exhibitor")
      }
      index += 1
    end
    threads.each do |t|
      t.join
    end
  end

  def exhibitor_stop(node)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' sv stop exhibitor")
  end
  
  def exhibitor_leader_stop(nodes)
    nodes.each do |node|
      if(node.handle.exec!("echo stat | nc localhost 2181 | grep Mode")).split(" ")[1] == "leader"
         node.handle.exec!("echo #{node.password} | sudo -S -p '' sv stop exhibitor")
         break
      end
    end
  end
  
  def exhibitor_follower_stop(nodes)
    nodes.each do |node|
      if(node.handle.exec!("echo stat | nc localhost 2181 | grep Mode")).split(" ")[1] == "follower"
         node.handle.exec!("echo #{node.password} | sudo -S -p '' sv stop exhibitor")
         break
      end
    end
  end
  
  def exhibitor_cluster_stop(nodes)
    threads = []
    index = 0
    nodes.each do |node|
      threads[index] = Thread.new(node){
      node.handle.exec!("echo #{node.password} | sudo -S -p '' sv stop exhibitor")
      }
      index += 1
    end
    threads.each do |t|
      t.join
    end
  end
  
  def exhibitor_start(node)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' sv start exhibitor")
  end
  
  def exhibitor_leader_start(nodes)
    nodes.each do |node|
      if(node.handle.exec!("echo stat | nc localhost 2181 | grep Mode")).split(" ")[1] == "leader"
         node.handle.exec!("echo #{node.password} | sudo -S -p '' sv start exhibitor")
         break
      end
    end
  end
  
  def exhibitor_follower_start(nodes)
    nodes.each do |node|
      if(node.handle.exec!("echo stat | nc localhost 2181 | grep Mode")).split(" ")[1] == "follower"
         node.handle.exec!("echo #{node.password} | sudo -S -p '' sv start exhibitor")
         break
      end
    end
  end
  
  def exhibitor_cluster_start(nodes)
    threads = []
    index = 0
    nodes.each do |node|
      threads[index] = Thread.new(node){
      node.handle.exec!("echo #{node.password} | sudo -S -p '' sv start exhibitor")
      }
      index += 1
    end
    threads.each do |t|
      t.join
    end
  end
  
end