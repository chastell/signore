module Signore class Wrapper

  def initialize text, meta
    @lines = text.split "\n"
    @meta  = meta
  end

  def display
    @lines.map! { |line| LovelyRufus::Wrapper.new(line).wrapped 80 }

    @lines << "[#{@meta}]"                               if @meta
    @lines.last.insert 0, ' ' * (width - @meta.size - 2) if @meta

    @lines.join "\n"
  end

  private

  def width
    @lines.map { |line| line.split "\n" }.flatten.map(&:size).max
  end

end end
