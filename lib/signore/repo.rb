require 'yaml/store'
require_relative 'mapper'
require_relative 'settings'
require_relative 'sig_finder'
require_relative 'signature'
require_relative 'tags'

module Signore
  class Repo
    def initialize(path: Settings.new.repo_path, sig_finder: SigFinder)
      @path       = path
      @sig_finder = sig_finder
    end

    def <<(sig)
      sigs << sig
      persist
    end

    def find(tags: Tags.new)
      sig_finder.find(sigs, tags: tags)
    end

    def sigs
      @sigs ||= begin
        elems = store.transaction(true) { store.fetch('signatures', []) }
        elems.map { |elem| elem.is_a?(Signature) ? elem : Mapper.from_h(elem) }
      end
    end

    private_attr_reader :path, :sig_finder

    private

    def persist
      hashes = sigs.map { |sig| Mapper.to_h(sig) }
      store.transaction { store['signatures'] = hashes }
    end

    def store
      @store ||= begin
        path.dirname.mkpath
        YAML::Store.new(path)
      end
    end
  end
end
