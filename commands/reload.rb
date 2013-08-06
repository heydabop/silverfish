def Commands.reload(socket, nick, channel, args)
  if AUTH_USERS.include? nick
    Dir["./commands/*.rb"].each {|file| load file}
  else
    tsputs "SEND: NOTICE #{nick} :I don't have to listen to you! You're not my real father!"
    socket.puts "NOTICE #{nick} :I don't have to listen to you! You're not my real father!"
  end
end
