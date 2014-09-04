require 'yaml/store'
require_relative '../spec_helper'
require_relative '../../lib/signore/sig_finder'
require_relative '../../lib/signore/tags'

module Signore
  describe SigFinder do
    let(:sigs) do
      store = YAML::Store.new('spec/fixtures/signatures.yml')
      store.transaction(true) { store['signatures'] }
    end

    let(:sig_finder) { SigFinder.new(sigs) }

    describe '.find' do
      it 'returns a random Signature by default' do
        SigFinder.find(sigs, random: Random.new(1981)).text
          .must_include 'Amateur fighter pilot ignores orders'
        SigFinder.find(sigs, random: Random.new(2009)).text
          .must_equal '// sometimes I believe compiler ignores all my comments'
      end

      it 'returns a random signature if the tags are empty' do
        SigFinder.find(sigs, tags: Tags.new, random: Random.new(2013)).text
          .must_equal '// sometimes I believe compiler ignores all my comments'
      end

      it 'returns a random signature based on provided tags' do
        SigFinder.find(sigs, tags: Tags.new(required: %w(programming))).text
          .must_equal '// sometimes I believe compiler ignores all my comments'
        SigFinder.find(sigs, tags: Tags.new(required: %w(work))).text
          .must_equal 'You do have to be mad to work here, but it doesn’t help.'
      end

      it 'returns a random signature based on required and forbidden tags' do
        tags = Tags.new(forbidden: %w(programming security), required: %w(tech))
        SigFinder.find(sigs, tags: tags).text
          .must_equal 'You do have to be mad to work here, but it doesn’t help.'
      end
    end
  end
end
