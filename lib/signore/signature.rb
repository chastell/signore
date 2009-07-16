module Signore class Signature < Sequel::Model

  many_to_many :labels, :class => 'Signore::Label'

  def self.find_random_by_labels labels
    labels.map { |label| Label[:name => label].signatures }.inject(:&).sort_by { rand }.first
  end

  def display
    # FIXME: figure out how to drop the force_encoding call
    case
    when author && source then "#{text} [#{author}, #{source}]"
    when author           then "#{text} [#{author}]"
    when source           then "#{text} [#{source}]"
    else text
    end.force_encoding 'UTF-8'
  end

end end
