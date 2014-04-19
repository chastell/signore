require 'optparse'
require 'ostruct'
require_relative 'database'
require_relative 'signature'

module Signore class Executable
  def initialize args = ARGV, db_factory: Database
    @settings = Settings.new args
    @db       = db_factory.new settings.db_path
    unless %w(prego pronto).include? settings.action
      abort 'usage: signore prego|pronto [tag, …]'
    end
  end

  def run input: $stdin
    sig = case settings.action
          when 'prego'  then handle_prego settings
          when 'pronto' then handle_pronto input
          end
    puts sig.to_s
  end

  attr_reader :db, :settings
  private     :db, :settings

  private

  Settings = Struct.new(*%i(action db_path forbidden_tags required_tags)) do
    def initialize args
      db_dir = ENV.fetch('XDG_DATA_HOME') { File.expand_path '~/.local/share' }
      self.db_path = "#{db_dir}/signore/signatures.yml"
      parse_settings args, self
      self.action = args.shift
      self.forbidden_tags, self.required_tags = args.partition do |tag|
        tag.start_with? '~'
      end
      forbidden_tags.map! { |tag| tag[1..-1] }
    end

    private

    def parse_settings args, settings
      OptionParser.new do |opts|
        opts.on '-d', '--database PATH', 'Database location' do |path|
          settings.db_path = path
        end
      end.parse! args
    end
  end

  def get_param param, input
    puts "#{param}?"
    value = ''
    value << input.gets until value.lines.to_a.last == "\n"
    value.strip
  end

  def handle_prego settings
    db.find required_tags: settings.required_tags,
            forbidden_tags: settings.forbidden_tags
  end

  def handle_pronto input
    params = params_from input
    sig = Signature.new params.text, params.author, params.source,
                        params.subject, settings.required_tags
    db << sig
    sig
  end

  def params_from input
    OpenStruct.new Hash[%i(text author subject source).map do |param|
      [param, get_param(param, input)]
    end].reject { |_, value| value.empty? }
  end
end end
