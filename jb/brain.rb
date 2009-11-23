require 'rubygems'
require 'ostruct'
require 'sinatra'
require 'brains/helpers'
require 'zombie'
require 'utils'

def register(name)
  tr = DNSSD::TextRecord.new
  tr["name"] = name
  DNSSD.register("#{name}'s brain", "_http._tcp,_brains", nil, 4567, tr)
end

register('JB')


post '/' do 
  #pass unless request.env['REMOTE_ADDR'] == "10.10.11.197"
  
  me = Robot.new(env)
  puts "\n\n\n--------------------------------------------------"
  puts me.inspect
  puts "-- enemy targeted --"
  puts me.nearest_zombie.inspect
  next_action = me.next_action
  puts "Next Action:\t\t#{next_action.inspect}"
  
  Robot.store_state(me)
  send *next_action
end
