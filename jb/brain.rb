require 'rubygems'
require 'sinatra'
require 'brains/helpers'
require 'zombie'
require 'utils'

brain :name => "JB"

post '/' do 
  puts env.to_json
  
  me = Robot.new(env)
  
  send *me.next_action
  
end
