# encoding: UTF-8

module Signore class Executable

  def initialize args = ARGV
    opts = Trollop.options args do
      opt :database, 'Location of the signature database', :default => (ENV['XDG_DATA_HOME'] or File.expand_path '~/.local/share') + '/signore/signatures.yml'
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
      params = Hash[[:text, :author, :subject, :source].map do |elem|
        output.puts "#{elem}?"
        value = ''
        value << input.gets until value.lines.to_a.last == "\n"
        [elem, value.rstrip]
      end].delete_if { |elem, value| value.empty? }
      sig = Signature.new params[:text], params[:author], params[:source], params[:subject], @tags
      Database.save sig
      output.puts sig.display
    end
  end

end end
