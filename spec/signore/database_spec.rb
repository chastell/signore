require 'tempfile'
require_relative '../spec_helper'
require_relative '../../lib/signore/database'
require_relative '../../lib/signore/signature'

module Signore describe Database do
  describe '#<<' do
    it 'saves the provided signature to disk' do
      text = 'Normaliser Unix c’est comme pasteuriser le camembert.'
      file = Tempfile.new ''
      Database.new(file.path) << Signature.new(text)
      file.read.must_include text
    end
  end

  describe '#find' do
    let(:path) { 'spec/fixtures/signatures.yml' }

    it 'returns a random signature by default' do
      store = YAML::Store.new path
      sigs  = store.transaction(true) { store['signatures'] }
      sig_finder = fake :sig_finder, as: :class
      args  = { forbidden: [], random: any(Random), required: [] }
      stub(sig_finder).find(sigs, args) { sigs.last }
      Database.new(path, sig_finder: sig_finder).find.text
        .must_include 'Amateur fighter pilot ignores orders'
    end

    it 'returns a random signature if the tags are empty' do
      store = YAML::Store.new path
      sigs  = store.transaction(true) { store['signatures'] }
      sig_finder = fake :sig_finder, as: :class
      args  = { forbidden: [], random: any(Random), required: [] }
      stub(sig_finder).find(sigs, args) { sigs.last }
      Database.new(path, sig_finder: sig_finder)
        .find(forbidden: [], required: []).text
        .must_include 'Amateur fighter pilot ignores orders'
    end

    it 'returns a random signature based on required and forbidden tags' do
      store = YAML::Store.new path
      sigs  = store.transaction(true) { store['signatures'] }
      sig_finder = fake :sig_finder, as: :class
      args  = {
        forbidden: %w(tech),
        random:    any(Random),
        required:  %w(programming security),
      }
      stub(sig_finder).find(sigs, args) { sigs.last }
      Database.new(path, sig_finder: sig_finder)
        .find(forbidden: %w(tech), required: %w(programming security)).text
        .must_include 'Amateur fighter pilot ignores orders'
    end
  end
end end
