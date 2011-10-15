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
      LovelyRufus::Wrapper.new(line).wrapped 80
    end
  end

end end
