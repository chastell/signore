require_relative 'signature'
require_relative 'tags'

module Signore
  class SigFinder
    def initialize(random: Random.new)
      @random = random
    end

    def find(sigs, tags: Tags.new)
      shuffled = sigs.shuffle(random: random)
      shuffled.find(-> { Signature.new }) { |sig| tags.match?(sig.tags) }
    end

    private

    private_attr_reader :random
  end
end
