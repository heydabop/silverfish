#!/usr/bin/ruby

require 'socket'
require './mcrcon.rb'
require './config.rb'
require './spawner.rb'

$tail_pid = 0 #i know, i know...

#puts with appended timestamp
def tsputs (string)
  puts "#{Time.now.strftime("%F %T")} #{string}"
end

module Commands
  #require all from commands directory
  Dir["./commands/*.rb"].each {|file| require file}
end

def identify (socket, passwd)
  tsputs "SEND: PRIVMSG NickServ :IDENTIFY #{passwd}"
  socket.puts "PRIVMSG NickServ :IDENTIFY #{passwd}"
end

#pong server
def pong (socket, server)
  tsputs "SEND: PONG #{server}"
  socket.puts "PONG #{server}"
end

irc = TCPSocket.new IRC_SERVER, IRC_PORT

spawner_thread = Thread.new{
  spawner irc
}

spawner_thread.join
sleep
