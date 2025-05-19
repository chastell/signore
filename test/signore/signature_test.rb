require 'yaml'
require_relative '../test_helper'
require_relative '../../lib/signore/signature'

module Signore # rubocop:disable Metrics/ModuleLength
  describe Signature do
    describe '.from_h' do
      it 'deserializes a Signature from a Hash' do
        text = 'For the sake of topic titles, I’d rather if Monty saved Python.'
        sig_hash = { 'author' => 'Anonymous Coward', 'source' => '/.',
                     'subject' => 'on ‘Monty Wants to Save MySQL’',
                     'tags' => %w[/. MySQL], 'text' => text }
        signature = Signature.new(author: 'Anonymous Coward', source: '/.',
                                  subject: 'on ‘Monty Wants to Save MySQL’',
                                  tags: %w[/. MySQL], text: text)
        _(Signature.from_h(sig_hash)).must_equal signature
      end
    end

    describe '.new' do
      it 'instantiates Signatures via parameters' do
        source = 'A History of Modern Computing'
        text   = 'In 1940 he summarized his work in an influential book, ' \
                 '‘Punched Card Methods in Scientific Computation’.'
        sig = Signature.new(author: 'Paul E. Ceruzzi', source: source,
                            subject: 'on Wallace Eckert',
                            tags: ['punched cards'], text: text)
        _(sig.author).must_equal 'Paul E. Ceruzzi'
        _(sig.source).must_equal source
        _(sig.subject).must_equal 'on Wallace Eckert'
        _(sig.tags).must_equal ['punched cards']
        _(sig.text).must_equal text
      end

      it 'nils empty parameters' do
        new = Signature.new(author: '', source: '', subject: '', tags: [],
                            text: '')
        _(new).must_equal Signature.new(author: '', source: '', subject: '',
                                        tags: [], text: '')
      end
    end

    describe '#empty?' do
      it 'is true when the Signature is a null object' do
        assert Signature.new.empty?
      end

      it 'is false when the Signature has some text' do
        refute Signature.new(text: 'Node.jk').empty?
      end
    end

    describe '#to_h' do
      it 'returns a String-keyed Hash representation of the Signature' do
        text = 'For the sake of topic titles, I’d rather if Monty saved Python.'
        sig  = Signature.new(author: 'Anonymous Coward', source: '/.',
                             subject: 'on ‘Monty Wants to Save MySQL’',
                             tags: %w[/. MySQL], text: text)
        _(sig.to_h).must_equal 'author' => 'Anonymous Coward', 'source' => '/.',
                               'subject' => 'on ‘Monty Wants to Save MySQL’',
                               'tags' => %w[/. MySQL], 'text' => text
      end

      it 'removes non-existing keys' do
        assert Signature.new.to_h.empty?
      end
    end

    describe '#to_s' do
      it 'is an empty String for an empty Signature' do
        _(Signature.new.to_s).must_equal ''
      end

      it 'does not show meta if there’s nothing to show' do
        text = "// sometimes I believe compiler\n// ignores all my comments"
        sig  = Signature.new(text: text)
        _(sig.to_s).must_equal text
      end

      it 'shows author on its own' do
        sig = Signature.new(author: 'kodz',
                            text: 'stay-at-home executives vs. wallstreet dads')
        _(sig.to_s).must_equal <<~end.strip
          stay-at-home executives vs. wallstreet dads
                                               [kodz]
        end
      end

      it 'shows author and source, comma-separated' do
        text = 'You do have to be mad to work here, but it doesn’t help.'
        sig  = Signature.new(author: 'Gary Barnes', source: 'asr', text: text)
        _(sig.to_s).must_equal <<~end.strip
          You do have to be mad to work
          here, but it doesn’t help.
                     [Gary Barnes, asr]
        end
      end

      it 'shows source on its own' do
        text = 'Bruce Schneier knows Alice and Bob’s shared secret.'
        sig  = Signature.new(source: 'Bruce Schneier Facts', text: text)
        _(sig.to_s).must_equal <<~end.strip
          Bruce Schneier knows Alice
          and Bob’s shared secret.
              [Bruce Schneier Facts]
        end
      end

      it 'shows author and subject, space separated' do
        text = 'More gangland camp than neo-noir.'
        sig = Signature.new(author: 'Nicholas Christopher',
                            subject: 'on Pulp Fiction', text: text)
        _(sig.to_s).must_equal <<~end.strip
          More gangland camp than neo-noir.
          [Nicholas Christopher on Pulp Fiction]
        end
      end

      it 'shows subject on its own' do
        text = 'Amateur fighter pilot ignores orders, listens ' \
               'to the voices in his head and slaughters thousands.'
        sig = Signature.new(subject: 'Star Wars ending explained', text: text)
        _(sig.to_s).must_equal <<~end.strip
          Amateur fighter pilot ignores orders, listens to
          the voices in his head and slaughters thousands.
                              [Star Wars ending explained]
        end
      end

      it 'handles edge cases properly' do
        wrappings = YAML.load_file('test/fixtures/wrapper.yml',
                                   permitted_classes: [Signature, Symbol])
        wrappings.each do |sig, wrapped|
          _(Signature.from_h(sig.to_h).to_s).must_equal wrapped
        end
      end
    end
  end
end
