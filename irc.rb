#!/usr/bin/ruby

require 'socket'

#puts with appended timestamp
def tsputs (string)
  puts "#{Time.now.strftime("%F %T")} #{string}"
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
tsputs "SEND: USER silvrfish * * :silvrfish"
irc.puts "USER silvrfish * * :silvrfish"

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
      if command == "botsnack"
        tsputs "SEND: PRIVMSG #minecraft :*rrrgghh*"
        irc.puts "PRIVMSG #minecraft :*rrrgghh*"
      end
      if command == "players"
        players = %x[/home/ross/bin/mcrcon -H 127.0.0.1 -p rossroll1234 -P 20155 list]
        players.sub!(":", ": ")
        players.rstrip!
        tsputs "SEND: PRIVMSG #minecraft :#{players}"
        irc.puts "PRIVMSG #minecraft :#{players}"
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
