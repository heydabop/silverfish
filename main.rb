#!/usr/bin/ruby

require 'socket'
require 'net/http'
require 'time'
require 'set'
require 'json'
require 'open-uri'
require './mcrcon.rb'
require './config.rb'
require './spawner.rb'
require './pass.rb'

AUTH_COMMANDS = ["join", "part", "restart", "start", "stop", "quit", "kick", "verbatim"]

#needed to work with later regex
if ". | ( ) [ ] { } \\ ^ $ + * ?".include?(COMMAND_PREFIX)
  RCOMMAND_PREFIX = "\\#{COMMAND_PREFIX}"
elsif
  RCOMMAND_PREFIX = COMMAND_PREFIX
end
  
$tail_pid = 0 #i know, i know...

#puts with appended timestamp
def tsputs (string)
  puts "#{Time.now.strftime("%F %T")} #{string}"
end

module Commands
  #require all from commands directory
  Dir["./commands/*.rb"].each {|file| load file}
end

def identify (socket, passwd)
  tsputs "SEND: PRIVMSG NickServ :IDENTIFY #{passwd}"
  socket.puts "PRIVMSG NickServ :IDENTIFY #{passwd}"
end

spawner_thread = Thread.new{
  spawner
}

spawner_thread.join
sleep
