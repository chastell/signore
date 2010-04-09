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
    @lines.last.insert 0, ' ' * (width - @meta.size - 2)
  end

  def width
    @lines.map { |line| line.split "\n" }.flatten.map(&:size).max
  end

  def wrap
    @lines.map! do |line|
      best_wrap = wrap_line_to line, 80
      79.downto 1 do |size|
        new_wrap = wrap_line_to line, size
        break if new_wrap.count("\n") > best_wrap.count("\n")
        best_wrap = new_wrap
      end
      best_wrap.chomp
    end
  end

  def wrap_line_to line, size
    line.gsub(/ ([^ ]) /, " \\1#{NBSP}").gsub(/(.{1,#{size}})( |$\n?)/, "\\1\n").tr NBSP, ' '
  end

end end
