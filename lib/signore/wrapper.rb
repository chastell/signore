# encoding: UTF-8

module Signore class Wrapper

  NBSP = ' '

  def initialize text, meta
    @lines = text.split "\n"
    @lines.last << " [#{meta.tr ' ', NBSP}]" if meta
    @meta = meta ? (meta.size + 2) : nil
  end

  def display
    wrap
    right_align_meta
    @lines.join("\n").tr NBSP, ' '
  end

  private

  def find_hangouts wrapped
    # FIXME: make it less ugly
    lines = wrapped.split "\n"
    lines.each_with_index do |line, nr|
      next unless line.include? ' '
      if (nr > 0 and line.rindex(' ') >= lines[nr - 1].size) or (nr < lines.size - 2 and line.rindex(' ') >= lines[nr + 1].size)
        lines[nr] << NBSP
        return lines.join(' ').gsub("#{NBSP} ", NBSP).rstrip
      end
    end
    nil
  end

  def right_align_meta
    return unless @meta
    @lines.map! { |l| l.split "\n" }.flatten!
    lenghts = @lines.map(&:size)
    if lenghts.size > 1 and lenghts.last == lenghts.max and lenghts.count(lenghts.last) == 1 and lenghts.last != @meta
      last = @lines.pop
      @lines << last[0...-@meta-1]
      @lines << last[-@meta..-1]
    end
    width = @lines.map(&:size).max
    @lines.last.insert(-@meta - 1, ' ' * (width - @lines.last.size))
  end

  def wrap
    @lines.map! do |line|
      wrapped = wrap_line line, line == @lines.last
      while fixed = find_hangouts(wrapped)
        wrapped = wrap_line fixed, line == @lines.last
      end
      wrapped
    end
  end

  def wrap_line line, is_last
    best_wrap = line.gsub(/(.{1,80})( |$\n?)/, "\\1\n")
    79.downto 1 do |size|
      new_wrap = line.gsub(/(.{1,#{size}})( |$\n?)/, "\\1\n")
      break if new_wrap.count("\n") > best_wrap.count("\n")
      lengths = new_wrap.split("\n").map(&:size)
      break if @meta and is_last and lengths.last == lengths.max and lengths.count(lengths.max) == 1
      best_wrap = new_wrap
    end
    best_wrap.chomp
  end

end end
