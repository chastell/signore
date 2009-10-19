# encoding: UTF-8

module Signore class Wrapper

  NBSP = ' '

  def initialize text, meta
    @lines = text.split "\n"
    @meta  = meta
    @seen  = Set[]
  end

  def display
    wrap
    add_meta if @meta
    @lines.join("\n").tr NBSP, ' '
  end

  private

  def add_meta
    @lines << "[#{@meta}]"
    @lines.map! { |l| l.split "\n" }.flatten!
    @lines.last.insert 0, ' ' * (@lines.map(&:size).max - @meta.size - 2)
  end

  def find_hangouts wrapped
    # FIXME: make it less ugly
    lines = wrapped.tr(NBSP, ' ').split "\n"
    lines.each_with_index do |line, nr|
      next unless line.include? ' '
      if (nr > 0 and line.rindex(' ') >= lines[nr - 1].size) or (nr < lines.size - 2 and line.rindex(' ') >= lines[nr + 1].size)
        lines[nr] << NBSP
        fixed = lines.join(' ').gsub("#{NBSP} ", NBSP).rstrip
        next if @seen.include? fixed
        @seen << fixed
        return fixed
      end
    end
    nil
  end

  def wrap
    @lines.map! do |line|
      wrapped = wrap_line line
      while fixed = find_hangouts(wrapped)
        wrapped = wrap_line fixed
      end
      wrapped
    end
  end

  def wrap_line line
    line.gsub!(/ (.) /, " \\1#{NBSP}")
    best_wrap = line.gsub(/(.{1,80})( |$\n?)/, "\\1\n")
    79.downto 1 do |size|
      new_wrap = line.gsub(/(.{1,#{size}})( |$\n?)/, "\\1\n")
      break if new_wrap.count("\n") > best_wrap.count("\n")
      best_wrap = new_wrap
    end
    best_wrap.chomp
  end

end end
