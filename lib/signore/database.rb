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
      sig_finder = SigFinder.new(store['signatures'], random: random)
      sig_finder.find_tagged forbidden_tags: forbidden_tags,
                             required_tags:  required_tags
    end
  end

  attr_reader :random, :store
  private     :random, :store

  class SigFinder
    def initialize sigs, random: Random.new
      @sigs   = sigs
      @random = random
    end

    def find_tagged forbidden_tags: [], required_tags: []
      sigs
        .select { |sig| required_tags.all?  { |tag| sig.tagged_with? tag } }
        .reject { |sig| forbidden_tags.any? { |tag| sig.tagged_with? tag } }
        .sample random: random
    end

    attr_reader :random, :sigs
    private     :random, :sigs
  end
end end
