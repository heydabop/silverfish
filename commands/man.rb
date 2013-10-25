def Commands.man(socket, nick, channel, args)
  com = args[0]
  manout = `man #{com}`
  if $?.exitstatus == 16
        tsputs "SEND: PRIVMSG #{channel} :No manual entry for #{com}"
        socket.puts "PRIVMSG #{channel} :No manual entry for #{com}"
  elsif((firstline = %r{(#{com} - .*)\n}i.match(manout)) != nil)
    tsputs "SEND: PRIVMSG #{channel} :#{firstline[1]}"
    socket.puts "PRIVMSG #{channel} :#{firstline[1]}"
  end
end
