module Signore class SigFinder
  def self.find sigs, forbidden: [], random: Random.new, required: []
    sig_finder = new sigs, random: random
    sig_finder.find_tagged forbidden: forbidden, required: required
  end

  def initialize sigs, random: Random.new
    @random = random
    @sigs   = sigs
  end

  def find_tagged forbidden: [], required: []
    sigs
      .select { |sig| required.all?  { |tag| sig.tagged_with? tag } }
      .reject { |sig| forbidden.any? { |tag| sig.tagged_with? tag } }
      .sample random: random
  end

  attr_reader :random, :sigs
  private     :random, :sigs
end end
