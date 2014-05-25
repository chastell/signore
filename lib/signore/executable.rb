require 'ostruct'
require_relative 'database'
require_relative 'executable/settings'
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
          when 'prego'  then handle_prego settings
          when 'pronto' then handle_pronto input
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

  def handle_prego settings
    db.find required: settings.required_tags,
            forbidden: settings.forbidden_tags
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
