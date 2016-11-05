# frozen_string_literal: true

require 'forwardable'
require 'yaml/store'
require_relative 'mapper'
require_relative 'settings'
require_relative 'sig_finder'
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
        hashes = store.transaction(true) { store.fetch('signatures', []) }
        hashes.map(&Mapper.method(:from_h))
      end
    end

    private

    attr_reader :path, :sig_finder

    def convert
      store.transaction do
        store['signatures'] = store.fetch('signatures', []).map(&:to_h)
      end
    end

    def legacy?
      path.exist? and path.read.include?('Signore::Signature')
    end

    def store
      @store ||= begin
        path.dirname.mkpath
        YAML::Store.new(path)
      end
    end
  end
end
