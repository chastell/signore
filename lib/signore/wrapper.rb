# encoding: UTF-8

module Signore class Wrapper

  NBSP = ' '

  def initialize text, meta
    @lines = text.split "\n"
    @meta  = meta
  end

  def display
    wrap
    add_meta if @meta
    @lines.join "\n"
  end

  private

  def add_meta
    @lines << "[#{@meta}]"
    @lines.map! { |l| l.split "\n" }.flatten!
    @lines.last.insert 0, ' ' * (@lines.map(&:size).max - @meta.size - 2)
  end

  def find_hangout wrapped
    lines = wrapped.split "\n"
    lines.each_with_index do |line, nr|
      space = line.rindex /[ #{NBSP}]/
      next unless space and nr < lines.size - 1
      return nr if nr > 0              and space >= lines[nr - 1].size
      return nr if nr < lines.size - 2 and space >= lines[nr + 1].size
      return nr if nr < lines.size - 1 and space >= lines[nr + 1].size and lines.size == 2
    end
    nil
  end

  def wrap
    @lines.map! do |line|
      wrap_line line
    end
  end

  def wrap_line line
    best_wrap = wrap_line_to line, 80
    79.downto 1 do |size|
      new_wrap = wrap_line_to line, size
      break if new_wrap.count("\n") > best_wrap.count("\n")
      best_wrap = new_wrap
    end
    best_wrap.chomp
  end

  def wrap_line_to line, size
    line = line.gsub(/ ([^ ]) /, " \\1#{NBSP}")
    line = line.gsub(/(.{1,#{size}})( |$\n?)/, "\\1\n")
    if hangout = find_hangout(line)
      lines = line.split "\n"
      lines[hangout] << NBSP
      line = lines.join(' ').gsub("#{NBSP} ", NBSP)
      line = wrap_line_to line, size
    end
    line.tr NBSP, ' '
  end

end end
