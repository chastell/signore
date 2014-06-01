require 'yaml/store'
require_relative '../spec_helper'
require_relative '../../lib/signore/settings'
require_relative '../../lib/signore/sig_finder'

module Signore describe SigFinder do
  let :sigs do
    store = YAML::Store.new 'spec/fixtures/signatures.yml'
    store.transaction(true) { store['signatures'] }
  end

  let(:sig_finder) { SigFinder.new sigs }

  describe '.find' do
    it 'returns a random Signature by default' do
      SigFinder.find(sigs, random: Random.new(1981)).text
        .must_include 'Amateur fighter pilot ignores orders'
      SigFinder.find(sigs, random: Random.new(2009)).text
        .must_include '// sometimes I believe compiler ignores all my comments'
    end

    it 'returns a random signature if the tags are empty' do
      kwargs = { tags: Settings::Tags.new, random: Random.new(2013) }
      SigFinder.find(sigs, kwargs).text
        .must_equal '// sometimes I believe compiler ignores all my comments'
    end

    it 'returns a random signature based on provided tags' do
      SigFinder.find(sigs, tags: Settings::Tags.new([], %w(programming))).text
        .must_equal '// sometimes I believe compiler ignores all my comments'
      SigFinder.find(sigs, tags: Settings::Tags.new([], %w(work))).text
        .must_equal 'You do have to be mad to work here, but it doesn’t help.'
    end

    it 'returns a random signature based on required and forbidden tags' do
      tags = Settings::Tags.new %w(programming security), %w(tech)
      SigFinder.find(sigs, tags: tags).text
        .must_equal 'You do have to be mad to work here, but it doesn’t help.'
    end
  end

  describe '#find_tagged' do
    it 'returns a random Signature by default' do
      SigFinder.new(sigs, random: Random.new(1981)).find_tagged.text
        .must_include 'Amateur fighter pilot ignores orders'
      SigFinder.new(sigs, random: Random.new(2009)).find_tagged.text
        .must_include '// sometimes I believe compiler ignores all my comments'
    end

    it 'returns a random signature if the tags are empty' do
      SigFinder.new(sigs, random: Random.new(2013))
        .find_tagged(tags: Settings::Tags.new).text
        .must_equal '// sometimes I believe compiler ignores all my comments'
    end

    it 'returns a random signature based on provided tags' do
      sig_finder.find_tagged(tags: Settings::Tags.new([], %w(programming))).text
        .must_equal '// sometimes I believe compiler ignores all my comments'
      sig_finder.find_tagged(tags: Settings::Tags.new([], %w(work))).text
        .must_equal 'You do have to be mad to work here, but it doesn’t help.'
    end

    it 'returns a random signature based on required and forbidden tags' do
      tags = Settings::Tags.new %w(programming security), %w(tech)
      sig_finder.find_tagged(tags: tags).text
        .must_equal 'You do have to be mad to work here, but it doesn’t help.'
    end
  end
end end
