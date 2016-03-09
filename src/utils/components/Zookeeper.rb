# Defines methods for operations possible on a Zookeeper cluster

require 'fileutils'
require 'csv'
require 'json'
require 'yaml'
require "net/ssh"

class Zookeeper
  
  def node_restart(node)
    node.handle.exec!("echo #{x.password} | sudo -S -p '' /usr/lib/zookeeper/bin/zkServer.sh restart")
  end
  
  def zk_leader_restart(nodes)
    nodes.each do |x|
      if(x.handle.exec!("echo stat | nc localhost 2181 | grep Mode")).split(" ")[1] == "leader"
         x.handle.exec!("echo #{x.password} | sudo -S -p '' /usr/lib/zookeeper/bin/zkServer.sh restart")
      end
    end
  end
  
  def zk_follower_restart(nodes)
    nodes.each do |x|
      if(x.handle.exec!("echo stat | nc localhost 2181 | grep Mode")).split(" ")[1] == "follower"
         x.handle.exec!("echo #{x.password} | sudo -S -p '' /usr/lib/zookeeper/bin/zkServer.sh restart")
      end
    end
  end

  def zk_cluster_restart(nodes)
    threads = []
    index = 0
    nodes.each do |node|
      threads[index] = Thread.new(node){
        x.handle.exec!("echo #{x.password} | sudo -S -p '' /usr/lib/zookeeper/bin/zkServer.sh restart")
      }
      index += 1
    end
    threads.each do |t|
      t.join
    end
  end
  
  def zk_node_stop(node)
    node.handle.exec!("echo #{x.password} | sudo -S -p '' /usr/lib/zookeeper/bin/zkServer.sh stop")
  end
  
  def zk_leader_stop(nodes)
    nodes.each do |x|
      if(x.handle.exec!("echo stat | nc localhost 2181 | grep Mode")).split(" ")[1] == "leader"
         x.handle.exec!("echo #{x.password} | sudo -S -p '' /usr/lib/zookeeper/bin/zkServer.sh stop")
      end
    end
  end

  def zk_follower_stop(nodes)
    nodes.each do |x|
      if(x.handle.exec!("echo stat | nc localhost 2181 | grep Mode")).split(" ")[1] == "follower"
         x.handle.exec!("echo #{x.password} | sudo -S -p '' /usr/lib/zookeeper/bin/zkServer.sh stop")
      end
    end
  end
 
  def zk_cluster_stop(nodes)
    threads = []
    index = 0
    nodes.each do |node|
      threads[index] = Thread.new(node){
        x.handle.exec!("echo #{x.password} | sudo -S -p '' /usr/lib/zookeeper/bin/zkServer.sh stop")
      }
      index += 1
    end
    threads.each do |t|
      t.join
    end
  end
  
  def zk_node_start(node)
    node.handle.exec!("echo #{x.password} | sudo -S -p '' /usr/lib/zookeeper/bin/zkServer.sh start")
  end
  
  def zk_cluster_start(nodes)
    threads = []
    index = 0
    nodes.each do |node|
      threads[index] = Thread.new(node){
        x.handle.exec!("echo #{x.password} | sudo -S -p '' /usr/lib/zookeeper/bin/zkServer.sh start")
      }
      index += 1
    end
    threads.each do |t|
      t.join
    end
  end
  
  def exhibitor_node_restart(node)
    node.handle.exec!("echo #{x.password} | sudo -S -p '' sv restart exhibitor")
  end
  
  def exhibitor_leader_restart(nodes)
    nodes.each do |x|
      if(x.handle.exec!("echo stat | nc localhost 2181 | grep Mode")).split(" ")[1] == "leader"
         x.handle.exec!("echo #{x.password} | sudo -S -p '' sv restart exhibitor")
      end
    end
  end
  
  def exhibitor_follower_restart(nodes)
    nodes.each do |x|
      if(x.handle.exec!("echo stat | nc localhost 2181 | grep Mode")).split(" ")[1] == "follower"
         x.handle.exec!("echo #{x.password} | sudo -S -p '' sv restart exhibitor")
      end
    end
  end
  
  def exhibitor_cluster_restart(nodes)
    nodes.each do |x|
      Thread.new(x){
         x.handle.exec!("echo #{x.password} | sudo -S -p '' sv restart exhibitor")
      }
    end
  end

  def exhibitor_node_stop(node)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' sv stop exhibitor")
  end
  
  def exhibitor_leader_stop(nodes)
    nodes.each do |x|
      if(x.handle.exec!("echo stat | nc localhost 2181 | grep Mode")).split(" ")[1] == "leader"
         x.handle.exec!("echo #{x.password} | sudo -S -p '' sv stop exhibitor")
      end
    end
  end
  
  def exhibitor_follower_stop(nodes)
    nodes.each do |x|
      if(x.handle.exec!("echo stat | nc localhost 2181 | grep Mode")).split(" ")[1] == "follower"
         x.handle.exec!("echo #{x.password} | sudo -S -p '' sv stop exhibitor")
      end
    end
  end
  
  def exhibitor_cluster_stop(nodes)
    nodes.each do |x|
      Thread.new(x){
         x.handle.exec!("echo #{x.password} | sudo -S -p '' sv stop exhibitor")
      }
    end
  end
  
  def exhibitor_node_start(node)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' sv start exhibitor")
  end
  
  def exhibitor_leader_start(nodes)
    nodes.each do |x|
      if(x.handle.exec!("echo stat | nc localhost 2181 | grep Mode")).split(" ")[1] == "leader"
         x.handle.exec!("echo #{x.password} | sudo -S -p '' sv start exhibitor")
      end
    end
  end
  
  def exhibitor_follower_start(nodes)
    nodes.each do |x|
      if(x.handle.exec!("echo stat | nc localhost 2181 | grep Mode")).split(" ")[1] == "follower"
         x.handle.exec!("echo #{x.password} | sudo -S -p '' sv start exhibitor")
      end
    end
  end
  
  def exhibitor_cluster_start(nodes)
    nodes.each do |x|
      Thread.new(x){
         x.handle.exec!("echo #{x.password} | sudo -S -p '' sv start exhibitor")
      }
    end
  end
  
end