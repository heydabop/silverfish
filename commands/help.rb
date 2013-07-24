def Commands.help(socket, nick, channel, args)
  tsputs "SEND: PRIVMSG #{channel} :Prefix commands in channel with #{COMMAND_PREFIX}, or /msg command (prefix optional). Try #{COMMAND_PREFIX}COMMANDS"
  socket.puts "PRIVMSG #{channel} :Prefix commands in channel with #{COMMAND_PREFIX}, or /msg command (prefix optional). Try #{COMMAND_PREFIX}COMMANDS"
end
