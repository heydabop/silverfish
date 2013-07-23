require './irc.rb'
require './mc_irc.rb'
require './console_in.rb'

def spawner
  begin
    irc_socket = TCPSocket.new IRC_SERVER, IRC_PORT
  rescue => e
    puts e.message
    puts e.backtrace.inspect
    sleep 120
    irc_spawner_thread = Thread.new{spawner}
    Thread.current.kill
  end
  mc_irc_thread = Thread.new{mc_irc irc_socket}
  console_in_thread = Thread.new{console_in irc_socket}
  begin
    irc irc_socket
  rescue => e
    puts e.message
    puts e.backtrace.inspect
    mc_irc_thread.kill
    #BUG: kill call makes zombie process: maybe fix with detatch
    Process.detach($tail_pid)
    system(%Q(kill #{$tail_pid})) #global, initialized in main.rb, set in mc_irc.rb
    console_in_thread.kill
    irc_socket.close
    puts "SLEEPING 120"
    sleep 120
    puts "RESTARTING"
    irc_spawner_thread = Thread.new{spawner}
  end
  mc_irc_thread.join
  console_in_thread.join
end
