require 'yaml/store'
require_relative 'settings'
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

  def find tags: Settings::Tags.new
    sigs = store.transaction(true) { store['signatures'] }
    sig_finder.find sigs, tags: tags
  end

  attr_reader :sig_finder, :store
  private     :sig_finder, :store
end end
