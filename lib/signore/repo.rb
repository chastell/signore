require 'forwardable'
require 'yaml/store'
require_relative 'settings'
require_relative 'sig_finder'
require_relative 'signature'
require_relative 'tags'

module Signore
  class Repo
    extend Forwardable

    def initialize(path: Settings.new.repo_path, sig_finder: SigFinder.new)
      @path       = path
      @sig_finder = sig_finder
      convert if legacy?
    end

    def <<(signature)
      store.transaction { (store['signatures'] ||= []) << signature.to_h }
    end

    delegate empty?: :sigs

    def find(tags: Tags.new)
      sig_finder.find(sigs, tags: tags)
    end

    def sigs
      @sigs ||= begin
        signatures.map(&Signature.method(:from_h))
      end
    end

    private

    attr_reader :path, :sig_finder

    def convert
      instances = signatures
      store.transaction { store['signatures'] = instances.map(&:to_h) }
    end

    def legacy?
      path.exist? and path.read.include?('Signore::Signature')
    end

    def signatures
      store.transaction(true) { store.fetch('signatures', []) }
    end

    def store
      @store ||= begin
        path.dirname.mkpath
        YAML::Store.new(path)
      end
    end
  end
end
