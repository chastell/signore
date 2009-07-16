module Signore class Signature < Sequel::Model

  many_to_many :labels, :class => 'Signore::Label'

  def self.find_random_by_labels labels
    labels.map { |label| Label[:name => label].signatures }.inject(:&).sort_by { rand }.first
  end

end end
