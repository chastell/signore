require 'lovely_rufus'

module Signore
  Signature = Struct.new(*%i(author source subject tags text)) do
    def initialize(author: nil, source: nil, subject: nil, tags: nil, text: nil)
      super author, source, subject, tags, text
      each_pair { |key, value| self[key] = nil if value and value.empty? }
    end

    def tagged_with?(tag)
      tags and tags.include?(tag)
    end

    def to_h
      super.map { |key, val| [key.to_s, val] }.to_h.keep_if { |_, value| value }
    end

    def to_s
      spaced   = text.gsub("\n", "\n\n")
      wrapped  = LovelyRufus.wrap(spaced, width: 80)
      squeezed = wrapped.gsub("\n\n", "\n").chomp
      squeezed + meta_for(squeezed)
    end

    private

    def indent_size_for(text)
      indent = text.split("\n").map(&:size).max - meta.size - 2
      indent < 0 ? 0 : indent
    end

    def meta
      stem = [author, subject].compact.join(' ')
      stem.empty? ? "#{source}" : [stem, source].compact.join(', ')
    end

    def meta_for(text)
      meta.empty? ? '' : "\n#{' ' * indent_size_for(text)}[#{meta}]"
    end
  end
end
