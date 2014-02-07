def Commands.btc(socket, nick, channel, args)
  json = URI.parse('https://btc-e.com/api/2/btc_usd/ticker').read
  ticker = JSON.parse(json)
  message = %Q(BTC/USD 24hr HI: $#{ticker["ticker"]["high"]} \u2014 24hr LOW: $#{ticker["ticker"]["low"]} \u2014 Buy: $#{ticker["ticker"]["buy"]} \u2014 Sell: $#{ticker["ticker"]["sell"]})
  tsputs "SEND: PRIVMSG #{channel} :#{message}"
  socket.puts "PRIVMSG #{channel} :#{message}"
end
