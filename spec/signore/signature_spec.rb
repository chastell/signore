require 'yaml'
require_relative '../spec_helper'
require_relative '../../lib/signore/signature'

module Signore
  describe Signature do
    describe '.new' do
      it 'instantiates Signatures via parameters' do
        source = 'A History of Modern Computing'
        text   = 'In 1940 he summarized his work in an influential book, ' \
          '‘Punched Card Methods in Scientific Computation’.'
        sig = Signature.new(text, author: 'Paul E. Ceruzzi', source: source,
                                  subject: 'on Wallace Eckert',
                                  tags: ['punched cards'])
        sig.author.must_equal 'Paul E. Ceruzzi'
        sig.source.must_equal source
        sig.subject.must_equal 'on Wallace Eckert'
        sig.tags.must_equal ['punched cards']
        sig.text.must_equal text
      end

      it 'nils empty parameters' do
        new = Signature.new('', author: '', source: '', subject: '', tags: [])
        new.must_equal Signature.new(nil, author: nil, source: nil,
                                          subject: nil, tags: nil)
      end
    end

    describe '#tagged_with?' do
      it 'says whether a tagged signature is tagged with a given tag' do
        sig = Signature.new('', tags: %w(programming tech))
        refute sig.tagged_with?('fnord')
        assert sig.tagged_with?('programming')
        assert sig.tagged_with?('tech')
      end

      it 'says that an untagged signature is not tagged with any tag' do
        refute Signature.new('').tagged_with?('fnord')
      end
    end

    describe '#to_s' do
      it 'does not show meta if there’s nothing to show' do
        text = '// sometimes I believe compiler ignores all my comments'
        sig  = Signature.new(text)
        sig.to_s.must_equal text
      end

      it 'shows author on its own' do
        sig = Signature.new('stay-at-home executives vs. wallstreet dads',
                            author: 'kodz')
        sig.to_s.must_equal <<-end.dedent.strip
          stay-at-home executives vs. wallstreet dads
                                               [kodz]
        end
      end

      it 'shows author and source, comma-separated' do
        text = 'You do have to be mad to work here, but it doesn’t help.'
        sig  = Signature.new(text, author: 'Gary Barnes', source: 'asr')
        sig.to_s.must_equal <<-end.dedent.strip
          You do have to be mad to work here, but it doesn’t help.
                                                [Gary Barnes, asr]
        end
      end

      it 'shows source on its own' do
        text = 'Bruce Schneier knows Alice and Bob’s shared secret.'
        sig  = Signature.new(text, source: 'Bruce Schneier Facts')
        sig.to_s.must_equal <<-end.dedent.strip
          Bruce Schneier knows Alice and Bob’s shared secret.
                                       [Bruce Schneier Facts]
        end
      end

      it 'shows author and subject, space separated' do
        text = 'She was good at playing abstract confusion ' \
        'in the same way a midget is good at being short.'
        sig = Signature.new(text, author: 'Clive James',
                                  subject: 'on Marilyn Monroe')
        sig.to_s.must_equal <<-end.dedent.strip
          She was good at playing abstract confusion in
          the same way a midget is good at being short.
                        [Clive James on Marilyn Monroe]
        end
      end

      it 'shows subject on its own' do
        text = 'Amateur fighter pilot ignores orders, listens ' \
          'to the voices in his head and slaughters thousands.'
        sig = Signature.new(text, subject: 'Star Wars ending explained')
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
  end
end
