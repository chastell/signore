require 'fileutils'
require 'pathname'
require 'tempfile'
require 'tmpdir'
require_relative '../spec_helper'
require_relative '../../lib/signore/database'
require_relative '../../lib/signore/signature'
require_relative '../../lib/signore/tags'

module Signore
  describe Database do
    describe '#<<' do
      let(:path) { Pathname.new(Tempfile.new('').path)                     }
      let(:sig)  { Signature.new(text: text)                               }
      let(:text) { 'Normaliser Unix c’est comme pasteuriser le camembert.' }

      it 'saves the provided signature to disk' do
        Database.new(path: path) << sig
        path.read.must_include text
      end

      it 'rewrites legacy YAML files on save' do
        FileUtils.cp Pathname.new('spec/fixtures/signatures.legacy.yml'), path
        Database.new(path: path) << sig
        path.read.wont_include 'Signore::Signature'
      end
    end

    describe '#find' do
      let(:database)   { Database.new(path: path, sig_finder: sig_finder) }
      let(:path)       { Pathname.new('spec/fixtures/signatures.yml')     }
      let(:sig_finder) { fake(:sig_finder, as: :class)                    }
      let(:store)      { YAML::Store.new(path)                            }
      let(:sigs) do
        store.transaction(true) { store['signatures'] }.map do |hash|
          Signature.from_h(hash)
        end
      end

      it 'returns a random signature by default' do
        stub(sig_finder).find(sigs, tags: Tags.new) { sigs.last }
        database.find.must_equal sigs.last
      end

      it 'returns a random signature based on required and forbidden tags' do
        tags = Tags.new(forbidden: %w(tech), required: %w(programming security))
        stub(sig_finder).find(sigs, tags: tags) { sigs.last }
        database.find(tags: tags).must_equal sigs.last
      end

      it 'doesn’t blow up if the path is missing' do
        begin
          tempdir = Dir.mktmpdir
          path = Pathname.new("#{tempdir}/some_intermediate_dir/sigs.yml")
          Database.new(path: path).find(tags: Tags.new).must_equal Signature.new
        ensure
          FileUtils.rmtree tempdir
        end
      end

      it 'keeps working with legacy YAML files' do
        path = Pathname.new('spec/fixtures/signatures.legacy.yml')
        database = Database.new(path: path, sig_finder: sig_finder)
        stub(sig_finder).find(sigs, tags: Tags.new) { sigs.last }
        database.find.must_equal sigs.last
      end
    end

    describe '#sigs' do
      it 'returns all the Signatures from the Database' do
        path = Pathname.new('spec/fixtures/signatures.yml')
        sigs = Database.new(path: path).sigs
        sigs.size.must_equal 6
        sigs.first.author.must_equal 'Clive James'
        sigs.last.subject.must_equal 'Star Wars ending explained'
      end
    end
  end
end
