require 'yaml/store'
require_relative '../spec_helper'
require_relative '../../lib/signore/sig_finder'

module Signore describe SigFinder do
  describe '#find_tagged' do
    it 'returns a random Signature by default' do
      store = YAML::Store.new 'spec/fixtures/signatures.yml'
      sigs  = store.transaction(true) { store['signatures'] }
      SigFinder.new(sigs, random: Random.new(1981)).find_tagged.text
        .must_include 'Amateur fighter pilot ignores orders'
      SigFinder.new(sigs, random: Random.new(2009)).find_tagged.text
        .must_include '// sometimes I believe compiler ignores all my comments'
    end
  end
end end
