# encoding: UTF-8

require_relative '../spec_helper'

module Signore describe Signature do
  describe '#tagged_with?' do
    it 'says whether a tagged signature is tagged with a given tag' do
      sig = Signature.new nil, nil, nil, nil, ['programming', 'tech']
      refute sig.tagged_with? 'fnord'
      assert sig.tagged_with? 'programming'
      assert sig.tagged_with? 'tech'
    end

    it 'says that an untagged signature is not tagged with any tag' do
      refute Signature.new.tagged_with? 'fnord'
    end
  end

  describe '#to_s' do
    it 'does not show meta if there’s nothing to show' do
      sig = Signature.new '// sometimes I believe compiler ignores all my comments'
      sig.to_s.must_equal <<-end.dedent.strip
        // sometimes I believe compiler ignores all my comments
      end
    end

    it 'shows author on its own' do
      sig = Signature.new 'stay-at-home executives vs. wallstreet dads', 'kodz'
      sig.to_s.must_equal <<-end.dedent.strip
        stay-at-home executives vs. wallstreet dads
                                             [kodz]
      end
    end

    it 'shows author and source, comma-separated' do
      sig = Signature.new 'You do have to be mad to work here, but it doesn’t help.', 'Gary Barnes', 'asr'
      sig.to_s.must_equal <<-end.dedent.strip
        You do have to be mad to work here, but it doesn’t help.
                                              [Gary Barnes, asr]
      end
    end

    it 'shows source on its own' do
      sig = Signature.new 'Bruce Schneier knows Alice and Bob’s shared secret.', nil, 'Bruce Schneier Facts'
      sig.to_s.must_equal <<-end.dedent.strip
        Bruce Schneier knows Alice and Bob’s shared secret.
                                     [Bruce Schneier Facts]
      end
    end

    it 'shows author and subject, space separated' do
      sig = Signature.new(
        'She was good at playing abstract confusion in the same way a midget is good at being short.',
        'Clive James', nil, 'on Marilyn Monroe')
      sig.to_s.must_equal <<-end.dedent.strip
        She was good at playing abstract confusion in
        the same way a midget is good at being short.
                      [Clive James on Marilyn Monroe]
      end
    end

    it 'shows subject on its own' do
      sig = Signature.new(
        'Amateur fighter pilot ignores orders, listens to the voices in his head and slaughters thousands.',
        nil, nil, 'Star Wars ending explained')
      sig.to_s.must_equal <<-end.dedent.strip
        Amateur fighter pilot ignores orders, listens to
        the voices in his head and slaughters thousands.
                            [Star Wars ending explained]
      end
    end

    it 'handles edge cases properly' do
      YAML.load_file('spec/fixtures/wrapper.yml').each do |sig, wrapped|
        sig.to_s.must_equal wrapped
      end
    end
  end
end end
