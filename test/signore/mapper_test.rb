require_relative '../test_helper'
require_relative '../../lib/signore/mapper'
require_relative '../../lib/signore/signature'

module Signore
  describe Mapper do
    let(:sig_hash) do
      {
        'author'  => 'Anonymous Coward',
        'source'  => '/.',
        'subject' => 'on ‘Monty Wants to Save MySQL’',
        'tags'    => %w(/. MySQL),
        'text'    => text,
      }
    end
    let(:signature) do
      Signature.new(author: 'Anonymous Coward', source: '/.',
                    subject: 'on ‘Monty Wants to Save MySQL’',
                    tags: %w(/. MySQL), text: text)
    end
    let(:text) do
      'For the sake of topic titles, I’d rather if Monty saved Python.'
    end

    describe '.from_h' do
      it 'deserializes a Signature from a Hash' do
        _(Mapper.from_h(sig_hash)).must_equal signature
      end
    end

    describe '.to_h' do
      it 'serialises a Signature to a Hash' do
        _(Mapper.to_h(signature)).must_equal sig_hash
      end
    end
  end
end
