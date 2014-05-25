require 'yaml/store'
require_relative 'sig_finder'

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
      sig_finder.find_tagged forbidden: forbidden_tags, required: required_tags
    end
  end

  attr_reader :random, :store
  private     :random, :store
end end
