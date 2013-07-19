#!/usr/bin/ruby

require 'socket'
require 'pp'
require './mcrcon.rb'

AUTH_USERS = ["heydabop"]

init_channels = ["#minecraft"]

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
    Commands.join irc, "heydabop", "null_channel", init_channels #2nd arg must be in Commands.auth_users
    break
  end
end

#puts output
out = Thread.new{
  while line = irc.gets.rstrip
    tsputs line
    #listen for a respond to pings
    if %r{^PING}.match(line) != nil
      server = line.split(':')[1]
      pong irc, server
      next
    end
    if line.include?("PRIVMSG") #chat message
      #extract nick
      index = line.index(':') + 1
      end_index = line.index('!') - 1
      nick = line[index..end_index]
      #end
      #extract chan
      index = line.index("PRIVMSG") + 8
      chan = line[index..line.length]
      end_index = chan.index(' ') - 1
      chan = chan[0..end_index]
      #end
      if chan == "#minecraft" #pipe to minecraft server
        index = line.index(':', 2) + 1
        message = line[index..line.length]
        message.tr!(%q("), %q('))
        if message.length > 100
          messages = Array.new
          while message.length > 100
            endIndex = message[0..99].rindex(' ')
            messages.push(message.slice!(0..endIndex))
          end
          messages.each {|msg| system(%Q(/home/ross/bin/mcrcon -H #{MC_HOST} -p #{MC_PASS} -P #{MC_PORT} "say <#{nick}> #{msg}"))}
          system(%Q(/home/ross/bin/mcrcon -H #{MC_HOST} -p #{MC_PASS} -P #{MC_PORT} "say <#{nick}> #{message}"))
        else
          system(%Q(/home/ross/bin/mcrcon -H #{MC_HOST} -p #{MC_PASS} -P #{MC_PORT} "say <#{nick}> #{message}"))
        end
      end
      #listen for commands, regex to watch for line beginning with & or for PMs
      if %r{PRIVMSG #[[:alnum:]]+ :&}.match(line) != nil || %r{PRIVMSG [[:alnum:]]+ :}.match(line) != nil
        #extract command and args
        if chan == "silvrfish" #is a PM
          chan = nick #respond with PM
          index = line.index(':', 2) + 1
          command = line[index..line.length].split(' ')[0]
          if command[0] == '&' #delete escape char if used
            command.slice!(0)
          end
          command_args = line[index..line.length].split(' ')
          command_args.delete_at(0)
        else #find command escape char
          #extract command and args
          index = line.index('&') + 1
          command = line[index..line.length].split(' ')[0]
          command_args = line[index..line.length].split(' ')
          command_args.delete_at(0)
          #end
        end
        command.downcase! #case insensitivity
        if Commands.respond_to? command
          Thread.new{ #MAOR THREDZ MAOR BETTUR
            begin
              Commands.send(command, irc, nick, chan, command_args)
            rescue
              pp $!
            end
          }
        else
          tsputs "SEND: NOTICE #{nick} :#{command} is not a valid command."
          irc.puts "NOTICE #{nick} :#{command} is not a valid command."
        end
      end
    end
  end
}

console_in = Thread.new{
  while input = gets
    tsputs "SEND: #{input}"
    irc.puts input
  end
}

#minecraft to irc chat bridge
mc_irc = Thread.new{
  IO.popen "tail -n 0 -f /home/ross/ftb/server.log" do |log_tail|
    until log_tail.eof?
      log_line = log_tail.readline.rstrip
      if %r{^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[INFO\] <\w+>}.match(log_line) != nil #chat message
        index = log_line.index('<') + 1
        endIndex = log_line.index('>')
        nick = log_line[index...endIndex]
        message = log_line[(endIndex+2)..log_line.length].rstrip
        tsputs "SEND: PRIVMSG #minecraft :<#{nick}> #{message}"
        irc.puts "PRIVMSG #minecraft :<#{nick}> #{message}"
      end
      if %r{^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[INFO\] User \w{,16} connecting}.match(log_line) != nil #join
        index = log_line.index(" [INFO] User ") + 13
        endIndex = log_line.index(" connecting ")
        nick = log_line[index...endIndex]
        tsputs "SEND: NOTICE #minecraft :#{nick} has joined"
        irc.puts "NOTICE #minecraft :#{nick} has joined"
      end
      if %r{^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[INFO\] \w{,16} lost connection}.match(log_line) != nil #quit
        index = log_line.index(" [INFO] ") + 8
        endIndex = log_line.index(" lost connection:")
        nick = log_line[index...endIndex]
        tsputs "SEND: NOTICE #minecraft :#{nick} has disconnected"
        irc.puts "NOTICE #minecraft :#{nick} has disconnected"
      end
    end
  end
}

out.join
console_in.join
