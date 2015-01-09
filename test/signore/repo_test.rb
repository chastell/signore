require 'fileutils'
require 'pathname'
require 'tempfile'
require 'tmpdir'
require_relative '../test_helper'
require_relative '../../lib/signore/repo'
require_relative '../../lib/signore/signature'
require_relative '../../lib/signore/tags'

module Signore
  describe Repo do
    describe '#<<' do
      let(:path) { Pathname.new(Tempfile.new('').path)                     }
      let(:sig)  { Signature.new(text: text)                               }
      let(:text) { 'Normaliser Unix c’est comme pasteuriser le camembert.' }

      it 'saves the provided signature to disk' do
        Repo.new(path: path) << sig
        path.read.must_include text
      end

      it 'rewrites legacy YAML files on save' do
        FileUtils.cp Pathname.new('test/fixtures/signatures.legacy.yml'), path
        Repo.new(path: path) << sig
        path.read.wont_include 'Signore::Signature'
      end
    end

    describe '#find' do
      let(:path)       { Pathname.new('test/fixtures/signatures.yml') }
      let(:repo)       { Repo.new(path: path, sig_finder: sig_finder) }
      let(:sig_finder) { fake(:sig_finder, as: :class)                }
      let(:sigs)       { repo.sigs                                    }
      let(:store)      { YAML::Store.new(path)                        }

      it 'returns a random signature by default' do
        stub(sig_finder).find(sigs, tags: Tags.new) { sigs.last }
        repo.find.must_equal sigs.last
      end

      it 'returns a random signature based on required and forbidden tags' do
        tags = Tags.new(forbidden: %w(tech), required: %w(programming security))
        stub(sig_finder).find(sigs, tags: tags) { sigs.last }
        repo.find(tags: tags).must_equal sigs.last
      end

      it 'doesn’t blow up if the path is missing' do
        begin
          tempdir = Dir.mktmpdir
          path = Pathname.new("#{tempdir}/some_intermediate_dir/sigs.yml")
          Repo.new(path: path).find(tags: Tags.new).must_equal Signature.new
        ensure
          FileUtils.rmtree tempdir
        end
      end

      it 'keeps working with legacy YAML files' do
        path = Pathname.new('test/fixtures/signatures.legacy.yml')
        repo = Repo.new(path: path, sig_finder: sig_finder)
        stub(sig_finder).find(sigs, tags: Tags.new) { sigs.last }
        repo.find.must_equal sigs.last
      end
    end

    describe '#sigs' do
      it 'returns all the Signatures from the Repo' do
        path = Pathname.new('test/fixtures/signatures.yml')
        sigs = Repo.new(path: path).sigs
        sigs.size.must_equal 6
        sigs.first.author.must_equal 'Clive James'
        sigs.last.subject.must_equal 'Star Wars ending explained'
      end
    end
  end
end
