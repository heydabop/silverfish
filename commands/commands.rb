def Irc.commands(socket, nick, channel, args)
  methods = Irc.methods - Module.methods #there's probably a better way to do this
  commands = ""
  methods.each do |method|
    method.upcase!
    commands = "#{commands} #{method}"
  end
  tsputs "SEND: PRIVMSG #{channel} :#{commands}"
  socket.puts "PRIVMSG #{channel} :#{commands}"
end
