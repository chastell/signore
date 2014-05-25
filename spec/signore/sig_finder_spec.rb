require 'yaml/store'
require_relative '../spec_helper'
require_relative '../../lib/signore/sig_finder'

module Signore describe SigFinder do
  let :sigs do
    store = YAML::Store.new 'spec/fixtures/signatures.yml'
    store.transaction(true) { store['signatures'] }
  end

  let(:sig_finder) { SigFinder.new sigs }

  describe '#find_tagged' do
    it 'returns a random Signature by default' do
      SigFinder.new(sigs, random: Random.new(1981)).find_tagged.text
        .must_include 'Amateur fighter pilot ignores orders'
      SigFinder.new(sigs, random: Random.new(2009)).find_tagged.text
        .must_include '// sometimes I believe compiler ignores all my comments'
    end

    it 'returns a random signature if the tags are empty' do
      SigFinder.new(sigs, random: Random.new(2013))
        .find_tagged(forbidden: [], required: []).text
        .must_equal '// sometimes I believe compiler ignores all my comments'
    end

    it 'returns a random signature based on provided tags' do
      sig_finder.find_tagged(required: %w(programming)).text
        .must_equal '// sometimes I believe compiler ignores all my comments'
      sig_finder.find_tagged(required: %w(work)).text
        .must_equal 'You do have to be mad to work here, but it doesn’t help.'
    end

    it 'returns a random signature based on required and forbidden tags' do
      tags = { forbidden: %w(programming security), required: %w(tech) }
      sig_finder.find_tagged(tags).text
        .must_equal 'You do have to be mad to work here, but it doesn’t help.'
    end
  end
end end
