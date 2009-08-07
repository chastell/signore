module Signore class Signature < Sequel::Model

  many_to_many :labels

  def self.find_random_by_labels labels
    sigs = labels.empty? ? all : labels.map { |label| Label[:name => label].signatures rescue [] }.inject(:&)
    sigs.sort_by { rand }.first
  end

  def self.create_with_labels params
    labels = params.delete(:labels) || []
    params.delete_if { |key, value| value.empty? }
    sig = self.create params
    labels.each { |label| sig.add_label Label.find_or_create :name => label }
    sig
  end

  def display
    # FIXME: figure out how to drop the force_encoding call
    wrapper = Wrapper.new text.force_encoding('UTF-8'), meta
    wrapper.display
  end

  private

  def meta
    # FIXME: figure out how to drop the force_encoding call
    meta = case
           when author && source then "#{author}, #{source}"
           when author           then "#{author}"
           when source           then "#{source}"
           end
    meta.force_encoding 'UTF-8' if meta
  end

end end
