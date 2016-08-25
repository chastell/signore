# frozen_string_literal: true

require 'yaml/store'
require_relative 'mapper'
require_relative 'settings'
require_relative 'sig_finder'
require_relative 'signature'
require_relative 'tags'

module Signore
  class Repo
    def initialize(path: Settings.new.repo_path, sig_finder: SigFinder.new)
      @path       = path
      @sig_finder = sig_finder
      convert if legacy?
    end

    def <<(sig)
      store.transaction { (store['signatures'] ||= []) << Mapper.to_h(sig) }
    end

    def empty?
      sigs.empty?
    end

    def find(tags: Tags.new)
      sig_finder.find(sigs, tags: tags)
    end

    def sigs
      @sigs ||= begin
        elems = store.transaction(true) { store.fetch('signatures', []) }
        elems.map do |elem|
          elem.is_a?(Signature) ? Mapper.from_h(elem.to_h) : Mapper.from_h(elem)
        end
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
