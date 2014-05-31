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
    let(:path)       { 'spec/fixtures/signatures.yml'                  }
    let(:sig_finder) { fake :sig_finder, as: :class                    }
    let(:sigs)       { store.transaction(true) { store['signatures'] } }
    let(:store)      { YAML::Store.new path                            }

    it 'returns a random signature by default' do
      stub(sig_finder).find(sigs, forbidden: [], required: []) { sigs.last }
      Database.new(path, sig_finder: sig_finder).find.text
        .must_include 'Amateur fighter pilot ignores orders'
    end

    it 'returns a random signature based on required and forbidden tags' do
      tags = { forbidden: %w(tech), required:  %w(programming security) }
      stub(sig_finder).find(sigs, tags) { sigs.last }
      Database.new(path, sig_finder: sig_finder)
        .find(forbidden: %w(tech), required: %w(programming security)).text
        .must_include 'Amateur fighter pilot ignores orders'
    end
  end
end end
