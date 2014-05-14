require 'yaml/store'

module Signore class Database
  def initialize path, random: Random.new
    @random = random
    @store  = YAML::Store.new path
  end

  def << sig
    store.transaction do
      store['signatures'] ||= []
      store['signatures'] << sig
    end
  end

  def find forbidden_tags: [], required_tags: []
    store.transaction true do
      SigFinder.new(random).find_random store['signatures'],
                                        forbidden_tags: forbidden_tags,
                                        required_tags:  required_tags
    end
  end

  attr_reader :random, :store
  private     :random, :store

  class SigFinder
    def initialize random = Random.new
      @random = random
    end

    def find_random sigs, forbidden_tags: [], required_tags: []
      sigs
        .select { |sig| required_tags.all?  { |tag| sig.tagged_with? tag } }
        .reject { |sig| forbidden_tags.any? { |tag| sig.tagged_with? tag } }
        .sample random: random
    end

    attr_reader :random
    private     :random
  end
end end
