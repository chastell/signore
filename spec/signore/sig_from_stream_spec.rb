require 'stringio'
require_relative '../spec_helper'
require_relative '../../lib/signore/sig_from_stream'

module Signore
  describe SigFromStream do
    describe '.sig_from' do
      it 'asks about signature parts' do
        input = StringIO.new("\n\n\n\n")
        capture_io do
          SigFromStream.sig_from input
        end.first.must_equal <<-end.dedent
          text?
          author?
          subject?
          source?
        end
      end

      it 'asks about signature parts and returns resulting signature' do
        input = StringIO.new <<-end.dedent
          You do have to be mad to work here, but it doesn’t help.

          Gary Barnes


          asr

        end
        sig = nil
        capture_io { sig = SigFromStream.sig_from input }
        text = 'You do have to be mad to work here, but it doesn’t help.'
        sig.must_equal Signature.new(author: 'Gary Barnes', source: 'asr',
                                     text: text)
      end

      it 'handles multi-line signatures' do
        input = StringIO.new <<-end.dedent
          ‘You’ve got an interesting accent. Subtle. I can’t place it.’
          ‘It’s text-to-speech… I was raised by smartphones.’

          Patrick Ewing\n\n\n
        end

        sig = nil
        capture_io { sig = SigFromStream.sig_from input }
        text = <<-end.dedent.strip
          ‘You’ve got an interesting accent. Subtle. I can’t place it.’
          ‘It’s text-to-speech… I was raised by smartphones.’
        end
        sig.must_equal Signature.new(author: 'Patrick Ewing', text: text)
      end
    end
  end
end
