require 'yaml/store'
require_relative '../test_helper'
require_relative '../../lib/signore/sig_finder'
require_relative '../../lib/signore/tags'

module Signore
  describe SigFinder do
    verify_contract SigFinder

    let(:sigs) do
      Repo.new(path: Pathname.new('test/fixtures/signatures.yml')).sigs
    end

    let(:sig_finder) { SigFinder.new }

    describe '#find' do
      it 'returns a random Signature by default' do
        _(SigFinder.new(random: Random.new(0)).find(sigs).text)
          .must_include 'Amateur fighter pilot ignores orders'
        _(SigFinder.new(random: Random.new(1)).find(sigs).text)
          .must_equal '// sometimes I believe compiler ignores all my comments'
      end

      it 'returns a random signature if the tags are empty' do
        _(SigFinder.new(random: Random.new(0)).find(sigs, tags: Tags.new).text)
          .must_include 'Amateur fighter pilot ignores orders'
      end

      it 'returns a random signature based on provided tags' do
        _(sig_finder.find(sigs, tags: Tags.new(required: %w(programming))).text)
          .must_equal '// sometimes I believe compiler ignores all my comments'
        _(sig_finder.find(sigs, tags: Tags.new(required: %w(work))).text)
          .must_equal 'You do have to be mad to work here, but it doesn’t help.'
      end

      it 'returns a random signature based on required and forbidden tags' do
        tags = Tags.new(forbidden: %w(programming security), required: %w(tech))
        _(sig_finder.find(sigs, tags: tags).text)
          .must_equal 'You do have to be mad to work here, but it doesn’t help.'
      end

      it 'returns a null object if there are no results' do
        _(sig_finder.find([])).must_equal Signature.new
      end
    end
  end
end
