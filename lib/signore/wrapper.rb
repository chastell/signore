module Signore class Wrapper

  NBSP = ' '

  def initialize text, meta
    @lines = text.split "\n"
    @lines.last << " [#{meta.tr ' ', NBSP}]" if meta
    @meta = meta ? (meta.size + 2) : nil
  end

  def display
    wrap
    lines = right_align_meta @lines.join "\n"
    lines.tr NBSP, ' '
  end

  private

  def right_align_meta lines
    return lines unless @meta
    lenghts = lines.split("\n").map(&:size)
    if lenghts.size > 1 and lenghts.last == lenghts.max and lenghts.count(lenghts.last) == 1
      lines[-@meta-1] = "\n"
    end
    lenghts = lines.split("\n").map(&:size)
    lines.insert -@meta - 1, ' ' * (lenghts.max - lenghts.last)
    lines
  end

  def wrap
    last_line = @lines.last
    @lines = @lines.map do |line|
      wrap_line line, line == last_line
    end
  end

  def wrap_line line, is_last
    best_wrap = line.gsub /(.{1,80})( |$\n?)/, "\\1\n"
    79.downto 1 do |size|
      new_wrap = line.gsub /(.{1,#{size}})( |$\n?)/, "\\1\n"
      break if new_wrap.count("\n") > best_wrap.count("\n")
      lengths = new_wrap.split("\n").map(&:size)
      break if @meta and is_last and lengths.last == lengths.max and lengths.count(lengths.max) == 1
      best_wrap = new_wrap
    end
    best_wrap.chomp
  end

end end
