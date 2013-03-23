require 'net/http'
require 'xmlsimple'

 
SCHEDULER.every '15m', :first_in => 0 do |job|
 	send_event('news', { :message => 'hello world'})
end