def Irc.say(socket, nick, channel, args)
  line = ""
  for word in args
    line = "#{line}#{word} "
  end
  tsputs "SEND: PRIVMSG #minecraft :#{line}"
  socket.puts "PRIVMSG #minecraft :#{line}"
end
