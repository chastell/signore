require_relative 'signature'
require_relative 'tags'

module Signore
  module SigFinder
    module_function

    def find(sigs, random: Random.new, tags: Tags.new)
      shuffled = sigs.shuffle(random: random)
      shuffled.find(-> { Signature.new }) { |sig| tags.match?(sig.tags) }
    end
  end
end
