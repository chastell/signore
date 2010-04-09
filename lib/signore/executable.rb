# encoding: UTF-8

module Signore class Executable

  def initialize args = ARGV
    opts = Trollop.options args do
      opt :database, 'Location of the signature database', :default => (ENV['XDG_CONFIG_HOME'] or File.expand_path '~/.config') + '/signore/signatures.yml'
    end
    Trollop.die 'usage: signore prego|pronto [label, …]' unless ['prego', 'pronto'].include? args.first
    Signore.load_db opts[:database]
    args.shift
    @no_tags, @tags = args.partition { |tag| tag[0] == '~' }
    @no_tags.map! { |tag| tag[1..-1] }
  end

  def run output = $stdout
    output.puts Signature.find(:tags => @tags, :no_tags => @no_tags).display
  end

end end
