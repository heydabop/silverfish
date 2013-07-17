def Commands.help(socket, nick, channel, args)
  tsputs "SEND: PRIVMSG #{channel} :Prefix commands in channel with &, or /msg command (prefix optional). Try &COMMANDS"
  socket.puts "PRIVMSG #{channel} :Prefix commands in channel with &, or /msg command (prefix optional). Try &COMMANDS"
end
