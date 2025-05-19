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
    let(:path) { Pathname.new(Tempfile.new.path) }

    describe '.default_path' do
      it 'honours XDG_DATA_HOME if it’s set' do
        old_xdg = ENV.delete('XDG_DATA_HOME')
        ENV['XDG_DATA_HOME'] = Dir.mktmpdir
        path = "#{ENV.fetch('XDG_DATA_HOME')}/signore/signatures.yml"
        _(Repo.default_path).must_equal Pathname.new(path)
      ensure
        FileUtils.rmtree ENV.fetch('XDG_DATA_HOME')
        old_xdg ? ENV['XDG_DATA_HOME'] = old_xdg : ENV.delete('XDG_DATA_HOME')
      end

      it 'defaults XDG_DATA_HOME to ~/.local/share if it’s not set' do
        old_xdg = ENV.delete('XDG_DATA_HOME')
        path    = File.expand_path('~/.local/share/signore/signatures.yml')
        _(Repo.default_path).must_equal Pathname.new(path)
      ensure
        ENV['XDG_DATA_HOME'] = old_xdg if old_xdg
      end
    end

    describe '.new' do
      it 'rewrites legacy file to hashes on first access' do
        FileUtils.cp Pathname.new('test/fixtures/signatures.legacy.yml'), path
        Repo.new(path: path)
        _(path.read).wont_include 'Signore::Signature'
      end
    end

    describe '#<<' do
      let(:sig)  { Signature.new(text: text)                               }
      let(:text) { 'Normaliser Unix c’est comme pasteuriser le camembert.' }

      it 'saves the provided signature to disk' do
        Repo.new(path: path) << sig
        _(path.read).must_include text
      end

      it 'rewrites legacy YAML files on save' do
        FileUtils.cp Pathname.new('test/fixtures/signatures.legacy.yml'), path
        Repo.new(path: path) << sig
        _(path.read).wont_include 'Signore::Signature'
      end

      it 'handles edge cases' do
        sig = Signature.new(author: '000___000')
        Repo.new(path: path) << sig
      end
    end

    describe '#empty?' do
      it 'is true when a repo is empty' do
        assert Repo.new(path: path).empty?
      end

      it 'is false when a repo is not empty' do
        FileUtils.cp Pathname.new('test/fixtures/signatures.legacy.yml'), path
        refute Repo.new(path: path).empty?
      end
    end

    describe '#sigs' do
      it 'returns all the Signatures from the Repo' do
        path = Pathname.new('test/fixtures/signatures.yml')
        sigs = Repo.new(path: path).sigs
        _(sigs.size).must_equal 6
        _(sigs.first.author).must_equal 'Gary Barnes'
        _(sigs.last.subject).must_equal 'Star Wars ending explained'
      end

      it 'keeps working with legacy YAML files' do
        legacy_path = Pathname.new('test/fixtures/signatures.legacy.yml')
        temp_path   = Pathname.new(Tempfile.new.path)
        FileUtils.cp legacy_path, temp_path
        legacy_repo = Repo.new(path: temp_path)
        new_repo = Repo.new(path: Pathname.new('test/fixtures/signatures.yml'))
        _(legacy_repo.sigs).must_equal new_repo.sigs
      end

      it 'doesn’t blow up if the path is missing' do
        tempdir = Dir.mktmpdir
        path = Pathname.new("#{tempdir}/some_intermediate_dir/sigs.yml")
        _(Repo.new(path: path).sigs).must_equal []
      ensure
        FileUtils.rmtree tempdir
      end
    end
  end
end
