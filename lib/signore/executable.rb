module Signore class Executable
  def initialize args = ARGV, db_factory: Database
    @settings = settings_from args
    @db       = db_factory.new settings.db_path
  end

  def run(input: $stdin)
    case settings.action
    when 'prego'
      sig = db.find required_tags: settings.required_tags,
        forbidden_tags: settings.forbidden_tags
    when 'pronto'
      params = params_from input
      sig = Signature.new params.text, params.author, params.source,
        params.subject, settings.required_tags
      db << sig
    end

    puts sig.to_s
  end

  attr_reader :db, :settings
  private     :db, :settings

  private

  def get_param param, input
    puts "#{param}?"
    value = ''
    value << input.gets until value.lines.to_a.last == "\n"
    value.strip
  end

  def settings_from args
    OpenStruct.new.tap do |settings|
      db_dir = ENV.fetch('XDG_DATA_HOME') { File.expand_path '~/.local/share' }
      settings.db_path = "#{db_dir}/signore/signatures.yml"
      parse_settings args, settings
      settings.action = args.shift
      settings.forbidden_tags, settings.required_tags = args.partition do |tag|
        tag.start_with? '~'
      end
      settings.forbidden_tags.map! { |tag| tag[1..-1] }
      unless ['prego', 'pronto'].include? settings.action
        abort 'usage: signore prego|pronto [tag, …]'
      end
    end
  end

  def params_from input
    OpenStruct.new Hash[[:text, :author, :subject, :source].map do |param|
      [param, get_param(param, input)]
    end].reject { |_, value| value.empty? }
  end

  def parse_settings args, settings
    OptionParser.new do |opts|
      opts.on '-d', '--database PATH', 'Database location' do |path|
        settings.db_path = path
      end
    end.parse! args
  end
end end
