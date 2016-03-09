# Wrapper class for HipChat APIs to be used within Quilt
# Methods defined to send a message to a given HipChat room, to send a message to a particular user using '@', to add a given user to a given room
# Text colorize options may be overridden

require 'net/http'
require 'json'

class HipChat
   
  def initialize(token, room)
    @token = token
    @room = room
    @base_url = 'https://api.hipchat.com/v2/'
  end

  def send(msg, col = 'yellow')
      url = @base_url + 'room/' + @room + '/notification' + '?auth_token=' + @token
      uri = URI(url)
      Net::HTTP.post_form(uri, 'message' => msg, 'message_format' => 'text', 'notify' => true, 'color' => col)
  end

  def sendToUser(msg, at_name, col = 'yellow')
    msg = '@' + at_name + ' ' + msg 
    send(msg, col)
  end

  def addUser(at_name)
    path = '/v2/' + 'room/' + @room + '/member/' + '@' + at_name + '?auth_token=' + @token
    http = Net::HTTP.new('https://api.hipchat.com')
    http.send_request('PUT', path)
  end

end
