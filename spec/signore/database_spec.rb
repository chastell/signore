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
      it 'saves the provided signature to disk' do
        text = 'Normaliser Unix c’est comme pasteuriser le camembert.'
        sig  = Signature.new(text: text)
        path = Pathname.new(Tempfile.new('').path)
        Database.new(path: path) << sig
        path.read.must_include text
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
  end
end
