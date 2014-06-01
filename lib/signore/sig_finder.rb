require_relative 'settings'

module Signore class SigFinder
  def self.find sigs, random: Random.new, tags: Settings::Tags.new
    sig_finder = new sigs, random: random
    sig_finder.find_tagged tags: tags
  end

  def initialize sigs, random: Random.new
    @random = random
    @sigs   = sigs
  end

  def find_tagged tags: Settings::Tags.new
    sigs
      .select { |sig| tags.required.all?  { |tag| sig.tagged_with? tag } }
      .reject { |sig| tags.forbidden.any? { |tag| sig.tagged_with? tag } }
      .sample random: random
  end

  attr_reader :random, :sigs
  private     :random, :sigs
end end
