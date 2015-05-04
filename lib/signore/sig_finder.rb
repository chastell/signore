require_relative 'signature'
require_relative 'tags'

module Signore
  class SigFinder
    def self.find(sigs, random: Random.new, tags: Tags.new)
      new(sigs, random: random).find_tagged(tags: tags)
    end

    def initialize(sigs, random: Random.new)
      @sigs = sigs.shuffle(random: random)
    end

    def find_tagged(tags: Tags.new)
      sigs.find { |sig| tags.match?(sig.tags) } or Signature.new
    end

    private_attr_reader :sigs
  end
end
