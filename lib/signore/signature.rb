module Signore class Signature < Struct.new :text, :author, :source, :subject, :tags

  def tagged_with? tag
    tags and tags.include? tag
  end

  def to_s
    lines = text.split("\n").map { |line| LovelyRufus::Wrapper.new(line).wrapped 80 }

    if meta
      lines << "[#{meta}]"
      max = lines.map { |line| line.split "\n" }.flatten.map(&:size).max
      lines.last.insert 0, ' ' * (max - meta.size - 2)
    end

    lines.join "\n"
  end

  private

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

end end
