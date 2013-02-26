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

  def find opts = {}
    required  = opts.fetch(:required_tags)  { [] }
    forbidden = opts.fetch(:forbidden_tags) { [] }

    store.transaction true do
      store['signatures']
        .select { |sig| required.all?  { |tag| sig.tagged_with? tag } }
        .reject { |sig| forbidden.any? { |tag| sig.tagged_with? tag } }
        .sample random: random
    end
  end

  attr_reader :random, :store
  private     :random, :store
end end
