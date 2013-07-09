#!/usr/bin/ruby

require 'socket'

#join channels
def join (socket, channels)
  for channel in channels
    puts "SEND: JOIN ##{channel}"
    socket.puts "JOIN ##{channel}"
  end
end

def identify (socket, passwd)
  puts "SEND: PRIVMSG NickServ :IDENTIFY #{passwd}"
  socket.puts "PRIVMSG NickServ :IDENTIFY #{passwd}"
end

#pong server
def pong (socket, server)
  puts "SEND: PONG #{server}"
  socket.puts "PONG #{server}"
end

channels = ["minecraft"]

irc = TCPSocket.new 'irc.tamu.edu', 6667

puts "SEND: NICK silvrfish"
irc.puts "NICK silvrfish"
puts "SEND: USER silvrfish * * :silvrfish"
irc.puts "USER silvrfish * * :silvrfish"

#wait for auth to finish, join channels and identify upon server sending 001
while line = irc.gets
  puts line
  if line.include? "001"
    identify irc, "ichaizeu"
    join irc, channels
    break
  end
end

#puts output
out = Thread.new{
  while line = irc.gets
    puts line
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
        puts "SEND: PRIVMSG #minecraft :*rrrgghh*"
        irc.puts "PRIVMSG #minecraft :*rrrgghh*"
      end
      if command == "players"
        players = %x[/home/ross/bin/mcrcon -H 127.0.0.1 -p rossroll1234 -P 20155 list]
        players.sub!(":", ": ")
        players.rstrip!
        puts "SEND: PRIVMSG #minecraft :#{players}"
        irc.puts "PRIVMSG #minecraft :#{players}"
      end
    end
  end
}

console_in = Thread.new{
  while input = gets
    puts "SEND: PRIVMSG #minecraft :#{input}"
    irc.puts "PRIVMSG #minecraft :#{input}"
  end
}

out.join
console_in.join
