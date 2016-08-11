Goblin
==============

![Status](https://img.shields.io/badge/status-beta-blue.svg?style=flat)
[![License](https://img.shields.io/badge/license-Apache-green.svg?style=flat)](http://git.bluejeansnet.com/amaurya/goblin_utils/blob/master/LICENSE)

What is Goblin?
--------------
A framework for automating resiliency testcases of cloud deployments. It is implemented in [ruby](https://www.ruby-lang.org/), inspired by various other testing frameworks like [testng](https://en.wikipedia.org/wiki/TestNG), [junit](https://en.wikipedia.org/wiki/JUnit), [ruby-testunit](https://en.wikibooks.org/wiki/Ruby_Programming/Unit_testing) etc. The design goal of Goblin is to provide more features specific to resiliency testing. It is built on top of our decades of experience with various test automation frameworks and resiliency test tooling. Goblin also comes with some out of the box libraries which helps you get started easily.

Where can you use Goblin?
--------------
In any Ubuntu based cloud application

Why should you use Goblin?
--------------
Provides a framework for running resiliency tests reliably, comes packed with a set of defined tests, and allows extension based on new needs. Ability to integrate tests via Jenkins and post execution steps on a HipChat room.

Current out of the box libraries - Zookeeper, Couchbase, RabbitMQ, MongoDB, Cassandra

Getting Started
--------------

### Install following gems:

- ssh-pass
- For Jenkins setup:
 	sudo gem install ci_reporter
 	sudo gem install ci_reporter_test_unit
 	
### Use the examples as a starting point

- cd src/tests/examples
- Create a new test .rb file for your component or use the provided TestSample.rb example as a reference.
- Make sure to override the validate, simulate_failure, and recover methods from TestBase in the inner Test classes.
- To induce failures, see the src/utils/core/Actions.rb class and use the methods provided as test steps.
- Create a directory under resources/environments/ or use the provided example
- Create a configuration file or update the example provided in resources/environments/example/config.yml
- Update the HipChat token/room if you have one.
- Create a test bed configuration file or update the example provided in resources/environments/example/nodes.yml and add your own server details. Update the encoded server password using utils/Encode_password.rb
- Run the script using: cd src/runner; ruby launcher.rb --files='../../src/tests/examples/TestSample.rb' --env='example'

What can you do with Goblin?
--------------

### Kill Process
	Provides an interface to force kill (kill -9) a process using its PID or process name, whichever available.
	For example:
	actions.kill(node, name)

### Stop / Restart Service
	Provides an interface to stop/start/restart a well know service available on the system, given its name. 
	For example:
	zookeeper.exhibitor_stop(node)

### Network Latency
	Provides an interface to introduce network latency using Linux utility (tc) between any two given hosts.
	For example:
	actions.network_latency(node, dest_ip, latency, interface)
	
### Packet Loss
	Provides an interface to introduce packet loss (in percentage of sent packets) using Linux utility (tc) between any two given hosts.
	For example:
	actions.packet_loss(node, dest_ip, loss_cent, interface)

### Port Block
	Provides an interface to block incoming and outgoing traffic on a given port for a given host. Usually used for creating a break in connectivity between two applications on different hosts communicating via a well known port. Uses Linux utility ‘iptables’.
	For example:
	actions.block_input_port(node, port)
	

Other Ruby gems in use
--------------
- getoptlong
- yaml
- net/ssh
- net/http
- fileutils
- csv
- json
- nokogiri

Future
--------------
- Installation via a gem
- Integration of any chat application
