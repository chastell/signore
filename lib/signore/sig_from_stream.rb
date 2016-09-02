# frozen_string_literal: true

require_relative 'signature'
require_relative 'tags'

module Signore
  class SigFromStream
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

    Params = Struct.new(*%i(text author subject source))

    def get_param(param)
      puts "#{param}?"
      param == :text ? multiline : input.gets.strip
    end

    def multiline
      value = ''
      value += input.gets until value.lines.to_a.last == "\n"
      value.strip
    end

    def params
      @params ||= Params.new(*Params.members.map(&method(:get_param)))
    end
  end
end
