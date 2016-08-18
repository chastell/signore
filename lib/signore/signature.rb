# frozen_string_literal: true

require 'lovely_rufus'

module Signore
  Signature = Struct.new(*%i(text author source subject tags)) do
    def initialize(author: '', source: '', subject: '', tags: [], text: '')
      super text, author, source, subject, tags
    end

    def empty?
      to_s.empty?
    end

    undef text if defined?(:text)
    def text
      self[:text] or ''
    end

    def to_h
      super.map { |key, val| [key.to_s, val] }.to_h.keep_if do |_, value|
        value and not value.empty?
      end
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
      indent.negative? ? 0 : indent
    end

    def meta
      stem = [author, subject].reject(&:empty?).join(' ')
      [stem, source].reject(&:empty?).join(', ')
    end

    def meta_for(text)
      meta.empty? ? '' : "\n#{' ' * indent_size_for(text)}[#{meta}]"
    end
  end
end
