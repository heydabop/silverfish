#!/usr/bin/ruby

require 'socket'

#puts with appended timestamp
def tsputs (string)
  puts "#{Time.now.strftime("%F %T")} #{string}"
end

module Irc
  #require all from commands directory
  Dir["./commands/*.rb"].each {|file| require file}
end

#join channels
def join (socket, channels)
  for channel in channels
    tsputs "SEND: JOIN ##{channel}"
    socket.puts "JOIN ##{channel}"
  end
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



channels = ["minecraft"]

irc = TCPSocket.new 'irc.tamu.edu', 6667

tsputs "SEND: NICK silvrfish"
irc.puts "NICK silvrfish"
tsputs "SEND: USER silvrfish silverfish.0xkohen.com * :silvrfish"
irc.puts "USER silvrfish silverfish.0xkohen.com * :silvrfish"

#wait for auth to finish, join channels and identify upon server sending 001
while line = irc.gets
  tsputs line
  if line.include? "001"
    identify irc, "ichaizeu"
    join irc, channels
    break
  end
end

#puts output
out = Thread.new{
  while line = irc.gets
    tsputs line
    #listen for a respond to pings
    if line.include? "PING :"
      server = line.split(':')[1]
      pong irc, server
      next
    end
    #listen for commands, regex to watch for line beginning with &
    unless %r{PRIVMSG #[[:alnum:]]+ :&}.match(line) == nil
      index = line.index('&') + 1
      command = line[index..line.length].split(' ')[0]
      if Irc.respond_to? command
        Irc.send(command, irc)
      else
        tsputs "ERROR: No command called #{command}"
      end
    end
  end
}

console_in = Thread.new{
  while input = gets
    tsputs "SEND: PRIVMSG #minecraft :#{input}"
    irc.puts "PRIVMSG #minecraft :#{input}"
  end
}

out.join
console_in.join
