# encoding: UTF-8

require_relative '../spec_helper'

class String
  def unindent
    gsub(/^#{self[/\A\s*/]}/, '').strip
  end
end

module Signore describe Signature do

  before do
    @confusion, @mad, @compiler, @bruce, @dads, @starwars = YAML.load_file 'spec/fixtures/signatures.yml'
  end

  describe '#display' do

    it 'returns a signature formatted with meta information (if available)' do
      @compiler.display.must_equal <<-END.unindent
        // sometimes I believe compiler ignores all my comments
      END

      @dads.display.must_equal <<-END.unindent
        stay-at-home executives vs. wallstreet dads
                                             [kodz]
      END

      @mad.display.must_equal <<-END.unindent
        You do have to be mad to work here, but it doesn’t help.
                                              [Gary Barnes, asr]
      END

      @bruce.display.must_equal <<-END.unindent
        Bruce Schneier knows Alice and Bob’s shared secret.
                                     [Bruce Schneier Facts]
      END

      @confusion.display.must_equal <<-END.unindent
        She was good at playing abstract confusion in
        the same way a midget is good at being short.
                      [Clive James on Marilyn Monroe]
      END

      @starwars.display.must_equal <<-END.unindent
        Amateur fighter pilot ignores orders, listens to
        the voices in his head and slaughters thousands.
                            [Star Wars ending explained]
      END
    end

  end

  describe '#tagged_with?' do

    it 'says whether a tagged signatura is tagged with a given tag' do
      refute @compiler.tagged_with? 'fnord'
      assert @compiler.tagged_with? 'programming'
      assert @compiler.tagged_with? 'tech'
    end

    it 'says that an untagged signature is not tagged with any tag' do
      refute @dads.tagged_with? 'fnord'
    end

  end

end end
