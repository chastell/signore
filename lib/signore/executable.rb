# encoding: UTF-8

module Signore class Executable

  def initialize args
    Trollop.die 'usage: signore prego|pronto [label, …]' unless ['prego', 'pronto'].include? args.first
  end

end end
