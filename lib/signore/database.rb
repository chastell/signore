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
      store['signatures']
        .select { |sig| required_tags.all?  { |tag| sig.tagged_with? tag } }
        .reject { |sig| forbidden_tags.any? { |tag| sig.tagged_with? tag } }
        .sample random: random
    end
  end

  attr_reader :store
  private     :store
end end
