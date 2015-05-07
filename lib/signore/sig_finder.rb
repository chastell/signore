require_relative 'signature'
require_relative 'tags'

module Signore
  module SigFinder
    module_function

    def find(sigs, random: Random.new, tags: Tags.new)
      found = sigs.shuffle(random: random).find { |sig| tags.match?(sig.tags) }
      found or Signature.new
    end
  end
end
