module Signore class Executable

  def initialize args = ARGV
    opts = Trollop.options args do
      opt :database, 'Location of the signature database', :default => File.expand_path('~/.signore/signore.db')
    end
    Trollop.die 'usage: signore prego|pronto [label, …]' unless ['prego', 'pronto'].include? args.first
    Signore.connect opts[:database]
    @action = args.shift
    @labels = args
  end

  def run output = $stdout, input = $stdin
    case @action
    when 'prego'
      sig = Signature.find_random_by_labels @labels
    when 'pronto'
      params = {:labels => @labels}
      [:text, :author, :source].each do |elem|
        output << "#{elem}? "
        params[elem] = input.gets.chomp
      end
      sig = Signature.create_with_labels params
    end
    output.puts sig.display
  end

end end
