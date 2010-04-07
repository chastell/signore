module Signore class Signature < Struct.new :text, :author, :source, :subject, :tags

  def self.find opts = {}
    opts = {:tags => [], :no_tags => []}.merge opts
    sigs = Signore.db.shuffle
    sigs.reject! { |sig| not sig.tags or (sig.tags & opts[:tags]).empty? } unless opts[:tags].empty?
    sigs.reject! { |sig| sig.tags and not (sig.tags & opts[:no_tags]).empty? }
    sigs.first
  end

  def display
    meta ? "#{text}\n#{' ' * (text.size - meta.size - 2)}[#{meta}]" : text
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
