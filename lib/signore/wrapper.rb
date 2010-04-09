module Signore class Wrapper

  def initialize text, meta
    @lines = text.split "\n"
    @meta  = meta
  end

  def display
    add_meta if @meta
    @lines.join "\n"
  end

  private

  def add_meta
    @lines << ' ' * (@lines.map(&:size).max - @meta.size - 2) + "[#{@meta}]"
  end

end end
