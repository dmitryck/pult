class Pult::Executor::Terminator

  def self.kill! pid
    Process.kill "TERM", pid
    Process.wait pid
  end
end
