module Signore class Signature < Sequel::Model

  many_to_many :labels, :class => 'Signore::Label'

  def self.find_random_by_labels labels
    sigs = labels.empty? ? all : labels.map { |label| Label[:name => label].signatures rescue [] }.inject(:&)
    sigs.sort_by { rand }.first
  end

  def self.create_with_labels params
    labels = params[:labels]
    params.delete_if { |key, value| not [:text, :author, :source].include? key }
    sig = self.create params
    labels.each { |label| sig.add_label Label.find_or_create :name => label }
    sig
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
