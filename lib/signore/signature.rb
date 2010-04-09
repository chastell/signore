module Signore class Signature < Struct.new :text, :author, :source, :subject, :tags

  def display
    Wrapper.new(text, meta).display
  end

  def tagged_with? tag
    tags and tags.include? tag
  end

  private

  def meta
    case
    when author && subject && source then "#{author} #{subject}, #{source}"
    when author && subject           then "#{author} #{subject}"
    when author && source            then "#{author}, #{source}"
    when author                      then "#{author}"
    when source                      then "#{source}"
    end
  end

end end
