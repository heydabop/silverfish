def Irc.help(socket, nick, channel, args)
  methods = Irc.methods - Module.methods #there's probably a better way to do this
  commands = ""
  methods.each do |method|
    method = method.upcase
    commands = "#{commands} #{method}"
  end
  tsputs "SEND: PRIVMSG #minecraft :#{commands}"
  socket.puts "PRIVMSG #minecraft :#{commands}"
end
