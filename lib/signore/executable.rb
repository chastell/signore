# encoding: UTF-8

module Signore class Executable

  def initialize args = ARGV
    opts = Trollop.options args do
      opt :database, 'Location of the signature database', :default => (ENV['XDG_CONFIG_HOME'] or File.expand_path '~/.config') + '/signore/signatures.yml'
    end
    Trollop.die 'usage: signore prego|pronto [label, …]' unless ['prego', 'pronto'].include? args.first
    Database.load opts[:database]
    @action = args.shift
    @no_tags, @tags = args.partition { |tag| tag[0] == '~' }
    @no_tags.map! { |tag| tag[1..-1] }
  end

  def run output = $stdout, input = $stdin
    case @action
    when 'prego'
      output.puts Database.find(:tags => @tags, :no_tags => @no_tags).display
    when 'pronto'
      params = {:tags => @tags}
      [:text, :author, :subject, :source].each do |elem|
        output.puts "#{elem}?"
        params[elem] = ''
        params[elem] << input.gets until params[elem].lines.to_a.last == "\n"
        params[elem].rstrip!
      end
      params.delete_if { |key, value| value.empty? }
      sig = Signature.new params[:text], params[:author], params[:source], params[:subject], params[:tags]
      Database.save sig
      output.puts sig.display
    end
  end

end end
