# frozen_string_literal: true

require 'procto'
require_relative 'signature'
require_relative 'tags'

module Signore
  class SigFromStream
    include Procto.call

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
      return get_text if param == :text
      puts
      puts "#{param}?"
      input.gets.strip
    end

    def get_text # rubocop:disable AccessorMethodName
      puts 'text?'
      input.gets("\n\n").strip
    end

    def params
      @params ||= Params.new(*Params.members.map(&method(:get_param)))
    end
  end
end
