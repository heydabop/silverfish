def Irc.commands socket
  methods = Irc.methods - Module.methods
  commands = ""
  methods.each do |method|
    method.upcase!
    commands = "#{commands} #{method}"
  end
  tsputs "SEND: PRIVMSG #minecraft :#{commands}"
  socket.puts "PRIVMSG #minecraft :#{commands}"
end
