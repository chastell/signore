require 'ostruct'
require_relative 'database'
require_relative 'settings'
require_relative 'signature'

module Signore class Executable
  def initialize args = ARGV, db_factory: Database
    @settings    = Settings.new args
    @db          = db_factory.new settings.db_path
    valid_action = %w(prego pronto).include? settings.action
    abort 'usage: signore prego|pronto [tag, …]' unless valid_action
  end

  def run input: $stdin
    sig = case settings.action
          when 'prego'
            db.find tags: settings.tags
          when 'pronto'
            db << InputParser.sig_from(input, tags: settings.tags)
          end
    puts sig.to_s
  end

  attr_reader :db, :settings
  private     :db, :settings

  module InputParser
    module_function

    def get_param param, input
      puts "#{param}?"
      value = ''
      value << input.gets until value.lines.to_a.last == "\n"
      value.strip
    end

    def params_from input
      OpenStruct.new Hash[%i(text author subject source).map do |param|
        [param, get_param(param, input)]
      end].reject { |_, value| value.empty? }
    end

    def sig_from input, tags: Tags.new
      params = params_from input
      Signature.new params.text, params.author, params.source, params.subject,
                    tags.required
    end
  end
end end
