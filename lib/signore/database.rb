require 'yaml/store'
require_relative 'sig_finder'

module Signore class Database
  def initialize path, random: Random.new
    @random     = random
    @store      = YAML::Store.new path
    @sig_finder = SigFinder
  end

  def << sig
    store.transaction do
      store['signatures'] ||= []
      store['signatures'] << sig
    end
  end

  def find forbidden: [], required: []
    sig_finder.find sigs, forbidden: forbidden, random: random,
                          required: required
  end

  attr_reader :random, :sig_finder, :store
  private     :random, :sig_finder, :store

  private

  def sigs
    store.transaction(true) { store['signatures'] }
  end
end end
