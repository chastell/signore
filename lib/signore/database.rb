# encoding: UTF-8

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

  def find opts = {}
    required  = opts.fetch(:tags)    { [] }
    forbidden = opts.fetch(:no_tags) { [] }

    store.transaction true do
      store['signatures']
        .select { |sig| required.all?  { |tag| sig.tagged_with? tag } }
        .reject { |sig| forbidden.any? { |tag| sig.tagged_with? tag } }
        .shuffle.first
    end
  end

  attr_reader :store
  private     :store
end end
