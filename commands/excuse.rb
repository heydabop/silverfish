def Commands.excuse(socket, nick, channel, args)
  html = Net::HTTP.get('programmingexcuses.com', '/')
  lines = html.split "\n"
  message = ""
  lines.each {|line|
    if line.include? %Q(href="/")
      endIndex = line.rindex %Q(</a>)
      index = (line.rindex %Q(;">), endIndex) + 3
      message = line[index...endIndex]
      break
    end
  }
  tsputs "SEND: PRIVMSG #{channel} :#{message}."
  socket.puts "PRIVMSG #{channel} :#{message}."
end
