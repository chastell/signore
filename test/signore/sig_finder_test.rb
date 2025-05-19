require 'yaml/store'
require_relative '../test_helper'
require_relative '../../lib/signore/sig_finder'
require_relative '../../lib/signore/signature'
require_relative '../../lib/signore/tags'

module Signore
  describe SigFinder do
    let(:sigs) do
      Repo.new(path: Pathname.new('test/fixtures/signatures.yml')).sigs
    end

    describe '#find' do
      it 'returns a random Signature by default' do
        _(SigFinder.find(sigs, random: Random.new(0)).text)
          .must_include 'Amateur fighter pilot ignores orders'
        _(SigFinder.find(sigs, random: Random.new(1)).text)
          .must_equal '// sometimes I believe compiler ignores all my comments'
      end

      it 'returns a random signature if the tags are empty' do
        _(SigFinder.find(sigs, random: Random.new(0), tags: Tags.new).text)
          .must_include 'Amateur fighter pilot ignores orders'
      end

      it 'returns a random signature based on provided tags' do
        _(SigFinder.find(sigs, tags: Tags.new(required: %w[programming])).text)
          .must_equal '// sometimes I believe compiler ignores all my comments'
        _(SigFinder.find(sigs, tags: Tags.new(required: %w[work])).text)
          .must_equal 'You do have to be mad to work here, but it doesn’t help.'
      end

      it 'returns a random signature based on required and forbidden tags' do
        tags = Tags.new(forbidden: %w[programming security], required: %w[tech])
        _(SigFinder.find(sigs, tags: tags).text)
          .must_equal 'You do have to be mad to work here, but it doesn’t help.'
      end

      it 'returns a null object if there are no results' do
        _(SigFinder.find([])).must_equal Signature.new
      end
    end
  end
end
