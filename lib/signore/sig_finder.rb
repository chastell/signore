require_relative 'tags'

module Signore
  class SigFinder
    def self.find(sigs, random: Random.new, tags: Tags.new)
      new(sigs, random: random).find_tagged(tags: tags)
    end

    def initialize(sigs, random: Random.new)
      @random = random
      @sigs   = sigs
    end

    def find_tagged(tags: Tags.new)
      sigs
        .select { |sig| tags.required.all?  { |tag| sig.tagged_with?(tag) } }
        .reject { |sig| tags.forbidden.any? { |tag| sig.tagged_with?(tag) } }
        .sample(random: random) or Signature.new
    end

    private_attr_reader :random, :sigs
  end
end
