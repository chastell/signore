# encoding: UTF-8

module Signore class Executable

  def initialize args
    Trollop.die 'usage: signore prego|pronto [label, …]' if args.empty?
  end

end end
