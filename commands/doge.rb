def Commands.doge(socket, nick, channel, args)
  json = URI.parse('https://coinex.pw/api/v2/trade_pairs').read
  ticker = Hash.new
 JSON.parse(json)["trade_pairs"].each do |tick|
    if tick["id"] == 49
      ticker = tick
    end
  end
 b = 100000000.0
  message = %Q(DOGE/LTC 24hr HI: \u0141#{ticker["rate_max"] / b} - 24hr LOW: \u0141#{ticker["rate_min"] / b} - Last: \u0141#{ticker["last_price"] / b})
  tsputs "SEND: PRIVMSG #{channel} :#{message}"
  socket.puts "PRIVMSG #{channel} :#{message}"
end
