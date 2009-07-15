module Signore class Executable

  def initialize args
    opts = Trollop.options args do
      opt :database, 'Location of the signature database', :default => File.expand_path('~/.signore/signore.db')
    end
    Trollop.die 'usage: signore prego|pronto [label, …]' unless ['prego', 'pronto'].include? args.first
    Signore.connect opts[:database]
  end

end end
