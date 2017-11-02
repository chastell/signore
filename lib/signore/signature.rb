require 'lovely_rufus'

module Signore
  # rubocop:disable Metrics/BlockLength
  Signature = Struct.new(:text, :author, :source, :subject, :tags) do
    def self.from_h(hash)
      new(hash.map { |key, value| [key.to_sym, value] }.to_h)
    end

    def initialize(author: '', source: '', subject: '', tags: [], text: '')
      super text, author, source, subject, tags
    end

    def empty?
      to_s.empty?
    end

    def to_h
      super.map { |key, val| { key.to_s => val } }.reduce({}, :merge)
           .compact.reject { |_, val| val.empty? }
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
