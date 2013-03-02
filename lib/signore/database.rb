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

  def find(required_tags: [], forbidden_tags: [])
    store.transaction true do
      store['signatures']
        .select { |sig| required_tags.all?  { |tag| sig.tagged_with? tag } }
        .reject { |sig| forbidden_tags.any? { |tag| sig.tagged_with? tag } }
        .sample random: random
    end
  end

  attr_reader :random, :store
  private     :random, :store
end end
