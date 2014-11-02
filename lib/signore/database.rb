require 'fileutils'
require 'yaml/store'
require_relative 'settings'
require_relative 'sig_finder'
require_relative 'signature'
require_relative 'tags'

module Signore
  class Database
    def self.sig_from_hash(hash)
      Signature.new(hash.map { |key, value| [key.to_sym, value] }.to_h)
    end

    def initialize(path: Settings.new.db_path, sig_finder: SigFinder)
      @path       = path
      @sig_finder = sig_finder
      initialise_store if path.zero? or not path.exist?
      @store      = YAML::Store.new(path)
    end

    def <<(sig)
      sigs << sig
      persist
    end

    def find(tags: Tags.new)
      sig_finder.find(sigs, tags: tags)
    end

    def sigs
      @sigs ||= store.transaction(true) { store['signatures'] }.map do |elem|
        elem.is_a?(Signature) ? elem : self.class.sig_from_hash(elem)
      end
    end

    attr_reader :path, :sig_finder, :store
    private     :path, :sig_finder, :store

    private

    def initialise_store
      FileUtils.mkdir_p path.dirname
      FileUtils.touch path
      YAML::Store.new(path).transaction { |store| store['signatures'] = [] }
    end

    def persist
      store.transaction { store['signatures'] = sigs.map(&:to_h) }
    end
  end
end
