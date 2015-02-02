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

    def repo_path
      dir = ENV.fetch('XDG_DATA_HOME') { File.expand_path('~/.local/share') }
      Pathname.new("#{dir}/signore/signatures.yml")
    end

    def tags
      Tags.new(forbidden: forbidden, required: required)
    end

    private_attr_reader :args

    private

    def forbidden
      tag_names.select { |tag| tag.start_with?('~') }.map { |tag| tag[1..-1] }
    end

    def required
      tag_names.reject { |tag| tag.start_with?('~') }
    end

    def tag_names
      args[1..-1] or []
    end
  end
end
