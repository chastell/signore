require 'forwardable'
require 'yaml/store'
require_relative 'settings'
require_relative 'signature'
require_relative 'tags'

module Signore
  class Repo
    extend Forwardable

    def initialize(path: Settings.new.repo_path)
      @path = path
      convert if legacy?
    end

    def <<(signature)
      self.signatures = signatures + [signature.to_h]
    end

    delegate empty?: :signatures

    def sigs
      signatures.map(&Signature.method(:from_h))
    end

    private

    attr_reader :path

    def convert
      self.signatures = signatures.map(&:to_h)
    end

    def legacy?
      path.exist? and path.read.include?('Signore::Signature')
    end

    def signatures
      store.transaction(true) { store.fetch('signatures', []) }
    end

    def signatures=(hashes)
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
