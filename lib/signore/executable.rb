module Signore class Executable

  def initialize args = ARGV
    opts = Trollop.options args do
      opt :database, 'Location of the signature database', :default => File.expand_path('~/.signore/signore.db')
    end
    Trollop.die 'usage: signore prego|pronto [label, …]' unless ['prego', 'pronto'].include? args.first
    Signore.connect opts[:database]
    args.shift
    @labels = args
  end

  def run output = $stdout
    output.puts Signature.find_random_by_labels(@labels).display
  end

end end
