module Signore class Wrapper

  def initialize text, meta
    @text, @meta = text, meta
  end

  def display
    @meta ? "#{@text}\n#{' ' * (@text.size - @meta.size - 2)}[#{@meta}]" : @text
  end

end end
