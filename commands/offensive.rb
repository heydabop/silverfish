def Commands.offensive(socket, nick, channel, args)
  fortune = `fortune -os`.gsub(/\t/, '  ').gsub(/(.*)\n(.*\n)/, '\1 / \2').rstrip.split("\n")
  fortune.each {|line|
    tsputs "SEND: PRIVMSG #{channel} :#{line}"
    socket.puts "PRIVMSG #{channel} :#{line}"
  }
end

