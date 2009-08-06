module Signore class Signature < Sequel::Model

  NBSP = ' '

  many_to_many :labels

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
    lines = right_align_meta lines
    lines.tr NBSP, ' '
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
    end.force_encoding('UTF-8').tr ' ', NBSP
  end

  def right_align_meta lines
    return lines unless has_meta?
    lenghts = lines.split("\n").map(&:size)
    if lenghts.size > 1 and lenghts.last == lenghts.max and lenghts.count(lenghts.last) == 1
      lines[-meta.size-1] = "\n"
    end
    lenghts = lines.split("\n").map(&:size)
    lines[-meta.size..-1] = ' ' * (lenghts.max - lenghts.last) + meta
    lines
  end

  def wrap lines
    lines.split("\n").map do |line|
      best_wrap = line.gsub /(.{1,80})( |$\n?)/, "\\1\n"
      max_height = best_wrap.count "\n"
      79.downto 1 do |size|
        new_wrap = line.gsub /(.{1,#{size}})( |$\n?)/, "\\1\n"
        lengths = new_wrap.split("\n").map(&:size)
        break if has_meta? and line == lines.split("\n").last and lengths.last == lengths.max and lengths.count(lengths.max) == 1
        break if new_wrap.count("\n") > max_height
        best_wrap = new_wrap
      end
      best_wrap.chomp
    end.join "\n"
  end

end end
