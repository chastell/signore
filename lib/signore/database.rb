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

  def find forbidden: [], required: []
    sig_finder = SigFinder.new sigs, random: random
    sig_finder.find_tagged forbidden: forbidden, required: required
  end

  attr_reader :random, :store
  private     :random, :store

  private

  def sigs
    store.transaction(true) { store['signatures'] }
  end
end end
