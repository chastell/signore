require 'stringio'
require 'tempfile'
require 'tmpdir'
require_relative '../spec_helper'
require_relative '../../lib/signore/cli'

module Signore
  describe CLI do
    describe '#initialize' do
      it 'prints usage if no command is given' do
        out = capture_io { -> { CLI.new [] }.must_raise SystemExit }.last
        out.must_include 'usage: signore prego|pronto [tag, …]'
      end

      it 'prints usage if a bogus command is given' do
        out = capture_io { -> { CLI.new ['bogus'] }.must_raise SystemExit }.last
        out.must_include 'usage: signore prego|pronto [tag, …]'
      end
    end

    describe '#run' do
      describe 'prego' do
        let(:db) { Database.new path: 'spec/fixtures/signatures.yml' }

        it 'prints a signature tagged with the provided tags' do
          args = %w(prego tech programming)
          out  = capture_io { CLI.new(args, db: db).run }.first
          sig  = "// sometimes I believe compiler ignores all my comments\n"
          out.must_equal sig
        end

        it 'prints a signature based on allowed and forbidden tags' do
          args = %w(prego ~programming tech ~security)
          out  = capture_io { CLI.new(args, db: db).run }.first
          out.must_equal <<-end.dedent
            You do have to be mad to work here, but it doesn’t help.
                                                  [Gary Barnes, asr]
          end
        end
      end

      describe 'pronto' do
        let(:db) { Database.new path: Tempfile.new('').path }

        it 'asks about signature parts and saves resulting signature' do
          input = StringIO.new <<-end.dedent
            The Wikipedia page on ADHD is like 20 pages long. That’s just cruel.

            Mark Pilgrim\n\n\n
          end
          args = %w(pronto Wikipedia ADHD)
          out  = capture_io { CLI.new(args, db: db).run input: input }.first
          out.must_equal <<-end.dedent
            text?
            author?
            subject?
            source?
            The Wikipedia page on ADHD is like 20 pages long. That’s just cruel.
                                                                  [Mark Pilgrim]
          end
          args = %w(prego Wikipedia ADHD)
          out  = capture_io { CLI.new(args, db: db).run }.first
          out.must_equal <<-end.dedent
            The Wikipedia page on ADHD is like 20 pages long. That’s just cruel.
                                                                  [Mark Pilgrim]
          end
        end

        it 'handles multi-line signatures' do
          input = StringIO.new <<-end.dedent
            ‘You’ve got an interesting accent. Subtle. I can’t place it.’
            ‘It’s text-to-speech… I was raised by smartphones.’

            Patrick Ewing\n\n\n
          end
          io = capture_io { CLI.new(['pronto'], db: db).run input: input }
          io.first.must_equal <<-end.dedent
            text?
            author?
            subject?
            source?
            ‘You’ve got an interesting accent. Subtle. I can’t place it.’
            ‘It’s text-to-speech… I was raised by smartphones.’
                                                          [Patrick Ewing]
          end
        end
      end
    end
  end
end
