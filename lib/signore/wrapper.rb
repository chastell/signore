module Signore class Wrapper

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
      best_wrap = line.gsub(/(.{1,80})( |$\n?)/, "\\1\n")
      79.downto 1 do |size|
        new_wrap = line.gsub(/(.{1,#{size}})( |$\n?)/, "\\1\n")
        break if new_wrap.count("\n") > best_wrap.count("\n")
        best_wrap = new_wrap
      end
      best_wrap.chomp
    end
  end

end end
