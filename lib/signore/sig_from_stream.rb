require_relative 'signature'
require_relative 'tags'

module Signore
  class SigFromStream
    Params = Struct.new(*%i(text author subject source))

    def self.sig_from(input, tags: Tags.new)
      new(input, tags: tags).to_sig
    end

    def initialize(input, tags: Tags.new)
      @input = input
      @tags  = tags
    end

    def to_sig
      Signature.new(author: params.author, source: params.source,
                    subject: params.subject, tags: tags.required,
                    text: params.text)
    end

    private

    attr_reader :input, :tags

    def get_param(param)
      puts "#{param}?"
      ''.tap do |value|
        value << input.gets until value.lines.to_a.last == "\n"
      end.strip
    end

    def params
      @params ||= Params.new(*Params.members.map { |name| get_param(name) })
    end
  end
end
