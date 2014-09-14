require 'fileutils'
require 'yaml/store'
require_relative 'settings'
require_relative 'sig_finder'
require_relative 'tags'

module Signore
  class Database
    def initialize(path: Settings.new.db_path, sig_finder: SigFinder)
      @path       = path
      @sig_finder = sig_finder
    end

    def <<(sig)
      store.transaction do
        store['signatures'] ||= []
        store['signatures'] << sig
      end
      sig
    end

    def find(tags: Tags.new)
      sigs = store.transaction(true) { store['signatures'] } || []
      sig_finder.find(sigs, tags: tags)
    end

    attr_reader :path, :sig_finder
    private     :path, :sig_finder

    private

    def store
      @store ||= begin
        unless path.exist?
          FileUtils.mkdir_p path.dirname
          FileUtils.touch path
        end
        YAML::Store.new(path)
      end
    end
  end
end
