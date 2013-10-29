module Signore
  Signature = Struct.new :text, :author, :source, :subject, :tags do
    class << self
      undef :[]
    end

    def self.[](author: nil, source: nil, subject: nil, tags: nil, text: nil)
      new text, author, source, subject, tags
    end

    def tagged_with? tag
      tags and tags.include? tag
    end

    def to_s
      wrapper = LovelyRufus::Wrapper.new text.gsub("\n", "\n\n")
      wrapped = wrapper.wrapped(80).gsub "\n\n", "\n"
      meta ? wrapped + meta_for(wrapped) : wrapped
    end

    private

    def indent_size_for text
      indent = text_width(text) - meta.size - 2
      indent < 0 ? 0 : indent
    end

    def meta
      case
      when author && subject && source then "#{author} #{subject}, #{source}"
      when author && subject           then "#{author} #{subject}"
      when author && source            then "#{author}, #{source}"
      when author                      then "#{author}"
      when source                      then "#{source}"
      when subject                     then "#{subject}"
      end
    end

    def meta_for text
      "\n#{' ' * indent_size_for(text)}[#{meta}]"
    end

    def text_width text
      text.split("\n").map(&:size).max
    end
  end
end
