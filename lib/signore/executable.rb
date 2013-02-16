# encoding: UTF-8

module Signore class Executable
  def initialize args = ARGV, opts = {}
    options = options_from args

    @db     = opts.fetch(:db_factory) { Database }.new options.db_path
    @action = options.action

    @required_tags  = options.required_tags
    @forbidden_tags = options.forbidden_tags
  end

  def run input = $stdin
    case action
    when 'prego'
      sig = db.find tags: required_tags, no_tags: forbidden_tags
    when 'pronto'
      params = params_from input
      sig = Signature.new params.text, params.author, params.source, params.subject, required_tags
      db << sig
    end

    puts sig.to_s
  end

  attr_reader :action, :db, :forbidden_tags, :required_tags
  private     :action, :db, :forbidden_tags, :required_tags

  private

  def get_param param, input
    puts "#{param}?"
    value = ''
    value << input.gets until value.lines.to_a.last == "\n"
    value.strip
  end

  def options_from args
    OpenStruct.new.tap do |options|
      db_dir = ENV.fetch('XDG_DATA_HOME') { File.expand_path '~/.local/share' }
      options.db_path = "#{db_dir}/signore/signatures.yml"
      parse_options args, options
      options.action = args.shift
      options.forbidden_tags, options.required_tags = args.partition { |tag| tag.start_with? '~' }
      options.forbidden_tags.map! { |tag| tag[1..-1] }
      abort 'usage: signore prego|pronto [tag, …]' unless ['prego', 'pronto'].include? options.action
    end
  end

  def params_from input
    OpenStruct.new Hash[[:text, :author, :subject, :source].map do |param|
      [param, get_param(param, input)]
    end].reject { |_, value| value.empty? }
  end

  def parse_options args, options
    OptionParser.new do |opts|
      opts.on '-d', '--database PATH', "Location of the signature database (default: #{options.db_path})" do |path|
        options.db_path = path
      end
    end.parse! args
  end
end end
