# encoding: UTF-8

require_relative '../spec_helper'

module Signore describe Signature do

  before do
    Database.load 'spec/fixtures/signatures.yml'
  end

  describe '#display' do

    it 'returns a signature formatted with meta information (if available)' do
      Database.db[2].display.must_equal '// sometimes I believe compiler ignores all my comments'
      Database.db[4].display.must_equal "stay-at-home executives vs. wallstreet dads\n                                     [kodz]"
      Database.db[1].display.must_equal "You do have to be mad to work here, but it doesn’t help.\n                                      [Gary Barnes, asr]"
      Database.db[3].display.must_equal "Bruce Schneier knows Alice and Bob’s shared secret.\n                             [Bruce Schneier Facts]"
      Database.db[0].display.must_equal "She was good at playing abstract confusion in\nthe same way a midget is good at being short.\n              [Clive James on Marilyn Monroe]"
      Database.db[5].display.must_equal "Amateur fighter pilot ignores orders, listens to\nthe voices in his head and slaughters thousands.\n                    [Star Wars ending explained]"
    end

  end

  describe '#tagged_with?' do

    it 'says whether a tagged signatura is tagged with a given tag' do
      refute Database.db[2].tagged_with? 'fnord'
      assert Database.db[2].tagged_with? 'programming'
      assert Database.db[2].tagged_with? 'tech'
    end

    it 'says that an untagged signature is not tagged with any tag' do
      refute Database.db[4].tagged_with? 'fnord'
    end

  end

end end
