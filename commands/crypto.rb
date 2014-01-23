def Commands.crypto(socket, nick, channel, args)
  c1 = args[0].downcase
  c2 = args[1].downcase
  if c1 != "btc" && c2 != "btc" && c1 != "ltc" && c2 != "ltc"
    tsputs "SEND: NOTICE #{nick} :Crypto exchange must be to or from LTC or BTC"
    socket.puts "NOTICE #{nick} :Crypto exchange must be to or from LTC or BTC"
    return
  end
  if c1 == c2
    c1.upcase!
    tsputs "SEND: PRIVMSG #{channel} :#{c1}/#{c1} Current: 1 #{c1}"
    socket.puts "PRIVMSG #{channel} :#{c1}/#{c1} Current: 1 #{c1}"
    return
  end
  swapped = false
  if c1 == "btc"
    c1,c2 = c2,c1
    swapped = true
  elsif c1 == "ltc" && c2 != "btc"
    c1,c2 = c2,c1
    swapped = true
  end
  json = URI.parse('https://coinex.pw/api/v2/trade_pairs').read
  ticker = Hash.new
  JSON.parse(json)["trade_pairs"].each do |tick|
    if tick["url_slug"] == "#{c1}_#{c2}"
      ticker = tick
      break
    end
  end
  if ticker.empty?
    tsputs "SEND: NOTICE #{nick} :Currency pair could not be found. :("
    socket.puts "NOTICE #{nick} :Currency pair could not be found. :("
    return
  end
  b = 100000000.0
  high = ticker["rate_max"]/b
  low = ticker["rate_min"]/b
  last = ticker["last_price"]/b
  if swapped
    high = 1/(high.to_f)
    low = 1/(low.to_f)
    last = 1/(last.to_f)
  end
  high = high.round 5
  low = low.round 5
  last = last.round 5
  c1.upcase!
  c2.upcase!
  if swapped
    message = %Q(#{c2}/#{c1} 24hr HI: #{high} #{c1} \u2014 24hr LOW: #{low} #{c1} \u2014 Last: #{last} #{c1})
  else
    message = %Q(#{c1}/#{c2} 24hr HI: #{high} #{c2} \u2014 24hr LOW: #{low} #{c2} \u2014 Last: #{last} #{c2})
  end
  tsputs "SEND: PRIVMSG #{channel} :#{message}"
  socket.puts "PRIVMSG #{channel} :#{message}"
end
