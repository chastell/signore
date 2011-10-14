# encoding: UTF-8

module Signore class Executable

  def initialize args = ARGV, db_class = Database
    opts = Trollop.options args do
      opt :database, 'Location of the signature database', default: (ENV['XDG_DATA_HOME'] or File.expand_path '~/.local/share') + '/signore/signatures.yml'
    end
    Trollop.die 'usage: signore prego|pronto [label, …]' unless ['prego', 'pronto'].include? args.first
    @db = db_class.new opts[:database]
    @action = args.shift
    @no_tags, @tags = args.partition { |tag| tag.start_with? '~' }
    @no_tags.map! { |tag| tag[1..-1] }
  end

  def run input = $stdin
    case @action
    when 'prego'
      sig = @db.find tags: @tags, no_tags: @no_tags
    when 'pronto'
      params = get_params input
      sig = Signature.new params[:text], params[:author], params[:source], params[:subject], @tags
      @db << sig
    end
    puts sig.display
  end

  private

  def get_param param, input
    puts "#{param}?"
    value = ''
    value << input.gets until value.lines.to_a.last == "\n"
    value.strip
  end

  def get_params input
    Hash[[:text, :author, :subject, :source].map do |elem|
      [elem, get_param(elem, input)]
    end].delete_if { |elem, value| value.empty? }
  end

end end
