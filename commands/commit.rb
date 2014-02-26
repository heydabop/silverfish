def Commands.commit(socket, nick, channel, args)
  page = Nokogiri::HTML(open("http://whatthecommit.com/"))
  message = page.css('p')[0].text.rstrip
  tsputs "SEND: PRIVMSG #{channel} :#{message}"
  socket.puts "PRIVMSG #{channel} :#{message}"
end
