require 'pathname'
require_relative 'tags'

module Signore
  class Settings
    def initialize(args = [])
      @args = args
    end

    def action
      args.first
    end

    def db_path
      db_dir = ENV.fetch('XDG_DATA_HOME') { File.expand_path('~/.local/share') }
      Pathname.new("#{db_dir}/signore/signatures.yml")
    end

    def tags
      Tags.new(forbidden: forbidden, required: required)
    end

    attr_reader :args
    private     :args

    private

    def forbidden
      args[1..-1].select { |tag| tag.start_with?('~') }.map { |tag| tag[1..-1] }
    end

    def required
      args[1..-1].reject { |tag| tag.start_with?('~') }
    end
  end
end
