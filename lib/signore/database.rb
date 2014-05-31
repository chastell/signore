require 'yaml/store'
require_relative 'sig_finder'

module Signore class Database
  def initialize path, sig_finder: SigFinder
    @sig_finder = sig_finder
    @store      = YAML::Store.new path
  end

  def << sig
    store.transaction do
      store['signatures'] ||= []
      store['signatures'] << sig
    end
  end

  def find forbidden: [], required: []
    sig_finder.find sigs, forbidden: forbidden, required: required
  end

  attr_reader :sig_finder, :store
  private     :sig_finder, :store

  private

  def sigs
    store.transaction(true) { store['signatures'] }
  end
end end
