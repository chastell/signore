# encoding: UTF-8

module Signore class Database

  def self.db
    @store.transaction(true) { @store['signatures'] } || []
  end

  def self.find opts = {}
    opts = {tags: [], no_tags: []}.merge opts
    db
      .select { |sig| opts[:tags].all?    { |tag| sig.tagged_with? tag } }
      .reject { |sig| opts[:no_tags].any? { |tag| sig.tagged_with? tag } }
      .shuffle.first
  end

  def self.load path
    @store = YAML::Store.new path
  end

  def self.save sig
    @store.transaction do
      @store['signatures'] ||= []
      @store['signatures'] << sig
    end
  end

end end
