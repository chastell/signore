require 'stringio'
require_relative '../spec_helper'
require_relative '../../lib/signore/sig_from_stream'

module Signore describe SigFromStream do
  describe '.sig_from' do
    it 'asks about signature parts and returns resulting signature' do
      input = StringIO.new <<-end.dedent
        The Wikipedia page on ADHD is like 20 pages long. That’s just cruel.

        Mark Pilgrim\n\n\n
      end

      sig = nil
      capture_io do
        sig = SigFromStream.sig_from input
      end.first.must_equal <<-end.dedent
        text?
        author?
        subject?
        source?
      end
      sig.must_equal Signature.new 'The Wikipedia page on ADHD is like 20 pages long. That’s just cruel.', 'Mark Pilgrim', '', '', []
    end

    it 'handles multi-line signatures' do
      input = StringIO.new <<-end.dedent
        ‘You’ve got an interesting accent. Subtle. I can’t place it.’
        ‘It’s text-to-speech… I was raised by smartphones.’

        Patrick Ewing\n\n\n
      end

      sig = nil
      capture_io do
        sig = SigFromStream.sig_from input
      end.first.must_equal <<-end.dedent
        text?
        author?
        subject?
        source?
      end
      sig.must_equal Signature.new "‘You’ve got an interesting accent. Subtle. I can’t place it.’\n‘It’s text-to-speech… I was raised by smartphones.’", 'Patrick Ewing', '', '', []
    end
  end
end end
