def Irc.help socket
  methods = Irc.methods - Module.methods
  commands = ""
  methods.each do |method|
    method = method.upcase
    commands = "#{commands} #{method}"
  end
  tsputs "SEND: PRIVMSG #minecraft :#{commands}"
  socket.puts "PRIVMSG #minecraft :#{commands}"
end
