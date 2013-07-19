require './irc.rb'
require './mc_irc.rb'
require './console_in.rb'

def spawner(irc)
  mc_irc_thread = Thread.new{mc_irc irc}
  console_in_thread = Thread.new{console_in irc}
  begin
    irc_new irc
  rescue IOError => e
    puts e.message
    if e.message == "Connection Error."
      mc_irc_thread.kill
      #BUG: kill call makes zombie process
      system(%Q(kill #{$tail_pid})) #global, initialized in main.rb, set in mc_irc.rb
      console_in_thread.kill
      irc.close
      sleep 60
      irc = TCPSocket.new IRC_SERVER, IRC_PORT
      irc_spawner_thread = Thread.new{irc_spawner irc}
    else
      mc_irc_thread.kill
      console_in_thread.kill
      Thread.current.kill
    end
  end
  mc_irc_thread.join
  console_in_thread.join
end
