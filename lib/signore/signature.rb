require 'lovely_rufus'

module Signore
  Signature = Struct.new(*%i(text author source subject tags)) do
    class << self
      undef :[]
    end

    def self.[](author: nil, source: nil, subject: nil, tags: nil, text: nil)
      new text, author: author, source: source, subject: subject, tags: tags
    end

    def initialize(text, author: nil, source: nil, subject: nil, tags: nil)
      super text, author, source, subject, tags
      each_pair { |key, value| self[key] = nil if value and value.empty? }
    end

    def tagged_with?(tag)
      tags and tags.include? tag
    end

    def to_s
      wrapped = LovelyRufus::TextWrapper.wrap text.gsub("\n", "\n\n"), width: 80
      squeezed = wrapped.gsub("\n\n", "\n").chomp
      squeezed + meta_for(squeezed)
    end

    private

    def indent_size_for(text)
      indent = text_width(text) - meta.size - 2
      indent < 0 ? 0 : indent
    end

    def meta
      stem = [author, subject].compact.join ' '
      stem.empty? ? "#{source}" : [stem, source].compact.join(', ')
    end

    def meta_for(text)
      meta.empty? ? '' : "\n#{' ' * indent_size_for(text)}[#{meta}]"
    end

    def text_width(text)
      text.split("\n").map(&:size).max
    end
  end
end
