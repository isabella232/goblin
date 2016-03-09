require 'base64'
require 'getoptlong'

=begin
This utility encodes a given server's password to Base64 so that passwords may not be stored in config files in plain text.
Goblin takes care of decoding the password when required to be sent across SSH handles.
=end

opts = GetoptLong.new(
[ '--password', GetoptLong::REQUIRED_ARGUMENT ]    
)

opts.each do |opt, arg|
  case opt
  when '--password'
    $password = arg
  end 
end

class Encoder

  def encode(str)
    puts Base64.encode64(str)
  end

end

obj = Encoder.new

obj.encode($password)