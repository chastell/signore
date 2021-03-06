require 'stringio'
require_relative '../test_helper'
require_relative '../../lib/signore/sig_from_stream'

module Signore
  describe SigFromStream do
    describe '.call' do
      it 'asks about signature parts' do
        io = capture_io { SigFromStream.call StringIO.new("\n\n\n\n\n") }
        _(io.first).must_equal <<~end

          text?

          author?

          subject?

          source?
        end
      end

      it 'asks about signature parts and returns resulting signature' do
        input = StringIO.new <<~end
          You do have to be mad to work here, but it doesn’t help.

          Gary Barnes

          asr
        end
        sig = nil
        capture_io { sig = SigFromStream.call input }
        text = 'You do have to be mad to work here, but it doesn’t help.'
        _(sig).must_equal Signature.new(author: 'Gary Barnes', source: 'asr',
                                        text: text)
      end

      it 'handles multi-line signatures' do
        input = StringIO.new <<~end
          ‘You’ve got an interesting accent. Subtle. I can’t place it.’
          ‘It’s text-to-speech… I was raised by smartphones.’

          Patrick Ewing


        end
        sig = nil
        capture_io { sig = SigFromStream.call input }
        text = <<~end.strip
          ‘You’ve got an interesting accent. Subtle. I can’t place it.’
          ‘It’s text-to-speech… I was raised by smartphones.’
        end
        _(sig).must_equal Signature.new(author: 'Patrick Ewing', text: text)
      end
    end
  end
end
