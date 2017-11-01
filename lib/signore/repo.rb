require 'forwardable'
require 'pathname'
require 'yaml/store'
require_relative 'signature'
require_relative 'tags'

module Signore
  class Repo
    extend Forwardable

    def self.default_path
      dir = ENV.fetch('XDG_DATA_HOME') { File.expand_path('~/.local/share') }
      Pathname.new(dir) / 'signore' / 'signatures.yml'
    end

    def initialize(path: self.class.default_path)
      @path = path
      convert if legacy?
    end

    def <<(signature)
      self.hashes = hashes + [signature.to_h]
    end

    delegate empty?: :hashes

    def sigs
      hashes.map(&Signature.method(:from_h))
    end

    private

    attr_reader :path

    def convert
      self.hashes = hashes.map(&:to_h)
    end

    def legacy?
      path.exist? and path.read.include?('Signore::Signature')
    end

    def hashes
      store.transaction(true) { store.fetch('signatures', []) }
    end

    def hashes=(hashes)
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
