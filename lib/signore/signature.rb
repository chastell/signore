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
    lines = text.force_encoding 'UTF-8'
    lines += " #{meta}" if has_meta?
    lines = wrap lines
    lines = right_align_meta lines, meta if has_meta?
    lines
  end

  private

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

  def right_align_meta lines, meta
    longest = lines.split("\n").map(&:size).max
    last = lines.lines.to_a.last.size
    lines[-meta.size..-1] = ' ' * (longest - last) + meta
    lines
  end

  def wrap lines
    best_wrap = lines.gsub /(.{1,80})( |$\n?)/, "\\1\n"
    max_height = best_wrap.count "\n"
    79.downto 1 do |size|
      new_wrap = lines.gsub /(.{1,#{size}})( |$\n?)/, "\\1\n"
      lengths = new_wrap.split("\n").map(&:size)
      break if has_meta? and lengths.last == lengths.max and lengths.count(lengths.max) == 1
      new_wrap.count("\n") > max_height ? break : best_wrap = new_wrap
    end
    best_wrap.chomp
  end

end end
