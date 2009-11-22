require 'rubygems'
require 'ostruct'
require 'sinatra'
require 'brains/helpers'
require 'zombie'
require 'utils'

brain :name => "JB"

post '/' do 
  
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
