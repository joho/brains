require 'rubygems'
require 'ostruct'
require 'sinatra'
require 'brains/helpers'
require 'zombie'
require 'utils'

brain :name => "JB"

post '/' do 
  puts env.to_json
  
  me = Robot.new(env)

  next_action = me.next_action
  
  puts next_action.inspect
  
  send *next_action
  
end
