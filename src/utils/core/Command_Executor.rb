class Command_Runner

  def linux_reboot(node)
    node.handle.exec!("shutdown -r now")
  end
  
  def block_input_port(node, port)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' iptables -A INPUT -p tcp --dport  #{port} -j REJECT")
  end

  def block_output_port(node, port)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' iptables -A OUTPUT -p tcp --dport  #{port} -j REJECT")
  end
  
  def unblock_output_port(node, port)  
    node.handle.exec!("echo #{node.password} | sudo -S -p '' iptables -I OUTPUT -p tcp --dport #{port} -j ACCEPT")
  end
  
  def unblock_input_port(node, port)  
    node.handle.exec!("echo #{node.password} | sudo -S -p '' iptables -I INPUT -p tcp --dport #{port} -j ACCEPT")
  end
  
  def packet_loss(node, dest_ip, loss_cent, interface)
    node.handle.exec!("echo #{node.password} | sudo -S -p '' tc qdisc add dev #{interface} root handle 1: prio")
    sleep 2
    node.handle.exec!("echo #{node.password} | sudo -S -p '' tc filter add dev #{interface} protocol ip parent 1:0 prio 3 u32 match ip dst #{dest_ip} flowid 1:3")
    sleep 2
    Thread.new {node.handle.exec!("echo #{node.password} | sudo -S -p '' tc qdisc add dev #{interface} parent 1:3 netem loss #{loss_cent}% ")}
  end
   
  def stop_packet_loss(node, interface)    
    node.handle.exec!("echo #{node.password} | sudo -S -p '' tc qdisc del dev #{interface} root")    
  end 
  
  def network_latency(node, dest_ip, latency)
    puts node.handle.exec!("echo #{node.password} | sudo -S -p '' tc qdisc add dev #{interface} root handle 1: prio")
    sleep 2
    puts node.handle.exec!("echo #{node.password} | sudo -S -p '' tc filter add dev #{interface} protocol ip parent 1:0 prio 3 u32 match ip dst #{dest_ip} flowid 1:3
    ")
    sleep 2
    Thread.new {node.handle.exec!("echo #{node.password} | sudo -S -p '' tc qdisc add dev #{interface} parent 1:3 netem delay #{latency}ms 50ms distribution normal")}
  end

  def stop_network_latency(node)    
    node.handle.exec!("echo #{node.password} | sudo -S -p '' tc qdisc del dev #{interface} root")    
  end 

end