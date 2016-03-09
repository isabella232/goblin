# How to get started with Goblin

## Install following gems:

- ssh-pass
- gem install test-unit -v 2.5.5
- For Jenkins setup:
 	sudo gem install ci_reporter
 	sudo gem install ci_reporter_test_unit
 	
## Use the examples as a starting point

- cd src/tests/examples
- Create a new test .rb file for your component or use the provided examples as a reference
- Make sure to have a prep_env, clean_env and test function in place
- Create a directory under resources/environments/ as use the provided example
- Create a config file or update the example provided in resources/environments/example/config.yml
- Update the HipChat token/room if you have one. Update the encoded server password using utils/Encode_password.rb
- Create a test bed config file or update the example provided in resources/environments/example/nodes.yml and add your own server details
- Run the script using: ruby test_file.rb --environment <env_name> 



### See [Getting Started](./docs/getting_started.md) page for details.