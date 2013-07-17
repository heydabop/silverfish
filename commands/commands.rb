def Commands.commands(socket, nick, channel, args)
  methods = Commands.methods - Module.methods #there's probably a better way to do this
  methods.sort!
  commands = ""
  methods.each do |method|
    commands = "#{commands}#{method.to_s.upcase!} "
  end
  tsputs "SEND: PRIVMSG #{channel} :#{commands}"
  socket.puts "PRIVMSG #{channel} :#{commands}"
end
