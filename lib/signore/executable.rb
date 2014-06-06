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
          when 'prego'  then db.find tags: settings.tags
          when 'pronto' then InputParser.save_sig_from db, input, settings
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

    def save_sig_from db, input, settings
      params = params_from input
      sig = Signature.new params.text, params.author, params.source,
                          params.subject, settings.tags.required
      db << sig
      sig
    end
  end
end end
