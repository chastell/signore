require 'yaml/store'

module Signore class Database
  def initialize path
    @store = YAML::Store.new path
  end

  def << sig
    store.transaction do
      store['signatures'] ||= []
      store['signatures'] << sig
    end
  end

  def find forbidden_tags: [], random: Random.new, required_tags: []
    store.transaction true do
      find_random_among store['signatures'], forbidden_tags: forbidden_tags,
                                             random:         random,
                                             required_tags:  required_tags
    end
  end

  attr_reader :store
  private     :store

  private

  def find_random_among sigs, forbidden_tags: forbidden_tags, random: random,
                        required_tags: required_tags
    sigs
      .select { |sig| required_tags.all?  { |tag| sig.tagged_with? tag } }
      .reject { |sig| forbidden_tags.any? { |tag| sig.tagged_with? tag } }
      .sample random: random
  end
end end
