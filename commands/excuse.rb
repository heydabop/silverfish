def Commands.excuse(socket, nick, channel, args)
  page = Nokogiri::HTML(open("http://programmingexcuses.com/"))
  message = page.css('a').text.rstrip
  tsputs "SEND: PRIVMSG #{channel} :#{message}."
  socket.puts "PRIVMSG #{channel} :#{message}."
end
