def Commands.botsnack(socket, nick, channel, args)
  tsputs "SEND: PRIVMSG #{channel} :This was probably meant for silvrfish..."
  socket.puts "PRIVMSG #{channel} :This was probably meant for silvrfish..."
end
