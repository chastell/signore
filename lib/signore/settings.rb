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

    # :reek:UtilityFunction
    def repo_path
      dir = ENV.fetch('XDG_DATA_HOME') { File.expand_path('~/.local/share') }
      Pathname.new("#{dir}/signore/signatures.yml")
    end

    def tags
      negated, required = tag_names.partition { |name| name.start_with?('~') }
      Tags.new(forbidden: negated.map { |neg| neg[1..-1] }, required: required)
    end

    private_attr_reader :args

    private

    def tag_names
      args[1..-1] or []
    end
  end
end
