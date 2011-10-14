# encoding: UTF-8

module Signore class Database

  def initialize path
    @store = YAML::Store.new path
  end

  def << sig
    @store.transaction do
      @store['signatures'] ||= []
      @store['signatures'] << sig
    end
  end

  def find opts = {}
    opts = { tags: [], no_tags: [] }.merge opts

    @store.transaction true do
      @store['signatures']
        .select { |sig| opts[:tags].all?    { |tag| sig.tagged_with? tag } }
        .reject { |sig| opts[:no_tags].any? { |tag| sig.tagged_with? tag } }
        .shuffle.first
    end
  end

end end
