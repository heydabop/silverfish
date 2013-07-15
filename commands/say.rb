def Commands.say(socket, nick, channel, args)
  line = ""
  for word in args
    line = "#{line}#{word} "
  end
  tsputs "SEND: PRIVMSG #{channel} :#{line}"
  socket.puts "PRIVMSG #{channel} :#{line}"
end
