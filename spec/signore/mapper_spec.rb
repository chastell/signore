require_relative '../spec_helper'
require_relative '../../lib/signore/mapper'
require_relative '../../lib/signore/signature'

module Signore
  describe Mapper do
    describe '.from_h' do
      it 'deserializes a Signature from a Hash' do
        text = 'For the sake of topic titles, I’d rather if Monty saved Python.'
        hash = {
          'author'  => 'Anonymous Coward',
          'source'  => '/.',
          'subject' => 'on ‘Monty Wants to Save MySQL’',
          'tags'    => %w(/. MySQL),
          'text'    => text,
        }
        sig = Signature.new(author: 'Anonymous Coward', source: '/.',
                            subject: 'on ‘Monty Wants to Save MySQL’',
                            tags: %w(/. MySQL), text: text)
        Mapper.from_h(hash).must_equal sig
      end
    end

    describe '.to_h' do
      it 'serialises a Signature to a Hash' do
        text = 'For the sake of topic titles, I’d rather if Monty saved Python.'
        sig = Signature.new(author: 'Anonymous Coward', source: '/.',
                            subject: 'on ‘Monty Wants to Save MySQL’',
                            tags: %w(/. MySQL), text: text)
        Mapper.to_h(sig).must_equal(
          'author'  => 'Anonymous Coward',
          'source'  => '/.',
          'subject' => 'on ‘Monty Wants to Save MySQL’',
          'tags'    => %w(/. MySQL),
          'text'    => text,
        )
      end
    end
  end
end
