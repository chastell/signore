module Signore class Signature < Sequel::Model

  many_to_many :labels, :class => 'Signore::Label'

  def self.find_random_by_labels labels
    sigs = labels.empty? ? all : labels.map { |label| Label[:name => label].signatures rescue [] }.inject(:&)
    sigs.sort_by { rand }.first
  end

  def self.create_with_labels params
    labels = params.delete(:labels) || []
    params.delete_if { |key, value| value.empty? }
    sig = self.create params
    labels.each { |label| sig.add_label Label.find_or_create :name => label }
    sig
  end

  def display
    # FIXME: figure out how to drop the force_encoding call
    line = text.force_encoding 'UTF-8'
    line += " #{meta}" if has_meta?
    line = wrap line
    line = fix_meta line, meta if has_meta?
    line
  end

  private

  def fix_meta text, meta
    longest = text.split("\n").map(&:size).max
    last = text.lines.to_a.last.size
    text[-meta.size..-1] = ' ' * (longest - last) + meta
    text
  end

  def has_meta?
    author or source
  end

  def meta
    # FIXME: figure out how to drop the force_encoding call
    case
    when author && source then "[#{author}, #{source}]"
    when author           then "[#{author}]"
    when source           then "[#{source}]"
    else ''
    end.force_encoding 'UTF-8'
  end

  def wrap text
    best = text.gsub /(.{1,80})( |$\n?)/, "\\1\n"
    best_size = best.count "\n"
    79.downto 1 do |size|
      new = text.gsub /(.{1,#{size}})( |$\n?)/, "\\1\n"
      lengths = new.split("\n").map(&:size)
      break if has_meta? and lengths.last == lengths.max and lengths.count(lengths.max) == 1
      new.count("\n") > best_size ? break : best = new
    end
    best.chomp
  end

end end
