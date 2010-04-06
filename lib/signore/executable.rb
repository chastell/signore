# encoding: UTF-8

module Signore class Executable

  def initialize args
    opts = Trollop.options args do
      opt :database, 'Location of the signature database', :default => (ENV['XDG_CONFIG_HOME'] or File.expand_path '~/.config') + '/signore/signatures.yml'
    end
    Trollop.die 'usage: signore prego|pronto [label, …]' unless ['prego', 'pronto'].include? args.first
    Signore.load_db opts[:database]
    args.shift
    @tags = args
  end

  def run output
    output.puts Signature.find(:tags => @tags).display
  end

end end
