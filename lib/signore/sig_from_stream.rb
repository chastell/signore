require_relative 'signature'
require_relative 'tags'

module Signore
  class SigFromStream
    def self.call(input, tags: Tags.new)
      new(input, tags: tags).call
    end

    def initialize(input, tags: Tags.new)
      @input = input
      @tags  = tags
    end

    def call
      Signature.new(author: params.author, source: params.source,
                    subject: params.subject, tags: tags.required,
                    text: params.text)
    end

    private

    attr_reader :input, :tags

    Params = Struct.new(:text, :author, :subject, :source)

    def get_param(param)
      puts "\n#{param}?"
      separator = param == :text ? "\n\n" : "\n"
      input.gets(separator).strip
    end

    def params
      @params ||= Params.new(*Params.members.map(&method(:get_param)))
    end
  end
end
