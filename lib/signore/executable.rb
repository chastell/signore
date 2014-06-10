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

  class InputParser
    def self.sig_from input, tags: Tags.new
      new(input, tags: tags).to_sig
    end

    def initialize input, tags: Tags.new
      @input = input
      @tags  = tags
    end

    def to_sig
      Signature.new params.text, params.author, params.source, params.subject,
                    tags.required
    end

    attr_reader :input, :tags
    private     :input, :tags

    private

    def get_param param
      puts "#{param}?"
      value = ''
      value << input.gets until value.lines.to_a.last == "\n"
      value.strip
    end

    def params
      @params ||= begin
        names = %i(text author subject source)
        hash = names.map { |name| [name, get_param(name)] }.to_h
        OpenStruct.new hash.reject { |_, value| value.empty? }
      end
    end
  end
end end
