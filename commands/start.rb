def Commands.start(socket, nick, channel, args)
  # require 'fcntl'

  # serveroutd = IO.sysopen("/home/ross/silverfish/serverout", "w")
  # serverout =  IO.open(serveroutd, "w")
  # outflags = serverout.fcntl(Fcntl::F_GETFL, 0)
  # serverout.fcntl(Fcntl::F_SETFL, Fcntl::O_NONBLOCK|outflags)

  # serverind = IO.sysopen("/home/ross/silverfish/serverin", "r")
  # serverin =  IO.open(serverind, "r")
  # inflags = serverin.fcntl(Fcntl::F_GETFL, 0)
  # serverin.fcntl(Fcntl::F_SETFL, Fcntl::O_NONBLOCK|inflags)

  if AUTH_USERS.include?(nick) || nick == "pdbogen"
    temp_log_file = IO.sysopen("/home/ross/silverfish/temp.log", "w")
    serverout = IO.open(temp_log_file, "w")

    #server_pid = Process.spawn("source /home/ross/.bashrc && ./ServerStart.sh", :chdir=>"/home/ross/ftb")
    server_pid = Process.spawn(%Q(/bin/bash -c "source /home/ross/.bashrc && ./ServerStart.sh"), :chdir=>"/home/ross/unleashed", [:out, :err]=>"/dev/null", :in=>"/dev/null")
    Process.detach(server_pid)
  end
end
