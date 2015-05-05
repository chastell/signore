require_relative 'signature'
require_relative 'tags'

module Signore
  class SigFinder
    def self.find(sigs, random: Random.new, tags: Tags.new)
      found = sigs.shuffle(random: random).find { |sig| tags.match?(sig.tags) }
      found or Signature.new
    end
  end
end
