module Signore class Signature < Sequel::Model

  many_to_many :labels
  plugin       :force_encoding, 'UTF-8'

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
    Wrapper.new(text, meta).display
  end

  private

  def meta
    auth = subject ? "#{author} #{subject}" : author
    meta = case
           when author && source then "#{auth}, #{source}"
           when author           then "#{auth}"
           when source           then "#{source}"
           end
  end

end end
