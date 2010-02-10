module Signore class Signature < Sequel::Model

  many_to_many :labels
  plugin       :force_encoding, 'UTF-8'

  def self.find_random_by_labels required, forbidden = []
    sigs = required.empty? ? all : required.map { |label| Label[:name => label].signatures rescue [] }.inject(:&)
    sigs -= forbidden.map { |label| Label[:name => label].signatures }.flatten
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
    Wrapper.new(text, meta).display
  end

  private

  def meta
    case
    when author && subject && source then "#{author} #{subject}, #{source}"
    when author && subject           then "#{author} #{subject}"
    when author && source            then "#{author}, #{source}"
    when author                      then "#{author}"
    when source                      then "#{source}"
    end
  end

end end
