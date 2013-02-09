# encoding: UTF-8

module Signore class Executable
  def initialize args = ARGV, options = {}
    database_dir  = ENV.fetch('XDG_DATA_HOME') { File.expand_path '~/.local/share' }
    database_path = "#{database_dir}/signore/signatures.yml"
    OptionParser.new do |opts|
      opts.on '-d', '--database PATH', "Location of the signature database (default: #{database_path})" do |path|
        database_path = path
      end
    end.parse! args
    abort 'usage: signore prego|pronto [label, …]' unless ['prego', 'pronto'].include? args.first

    database_factory = options.fetch(:database_factory) { Database }
    @db = database_factory.new database_path

    @action = args.shift

    @no_tags, @tags = args.partition { |tag| tag.start_with? '~' }
    @no_tags.map! { |tag| tag[1..-1] }
  end

  def run input = $stdin
    case action
    when 'prego'
      sig = db.find tags: tags, no_tags: no_tags
    when 'pronto'
      params = get_params input
      sig = Signature.new params[:text], params[:author], params[:source], params[:subject], tags
      db << sig
    end

    puts sig.to_s
  end

  attr_reader :action, :db, :no_tags, :tags
  private     :action, :db, :no_tags, :tags

  private

  def get_param param, input
    puts "#{param}?"
    value = ''
    value << input.gets until value.lines.to_a.last == "\n"
    value.strip
  end

  def get_params input
    Hash[[:text, :author, :subject, :source].map do |param|
      [param, get_param(param, input)]
    end].reject { |_, value| value.empty? }
  end
end end
