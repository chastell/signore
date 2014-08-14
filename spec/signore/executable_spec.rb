require 'stringio'
require 'tempfile'
require 'tmpdir'
require_relative '../spec_helper'
require_relative '../../lib/signore/executable'

module Signore
  describe Executable do
    describe '#initialize' do
      it 'prints usage if no command is given' do
        capture_io do
          -> { Executable.new [] }.must_raise SystemExit
        end.last.must_include 'usage: signore prego|pronto [tag, …]'
      end

      it 'prints usage if a bogus command is given' do
        capture_io do
          -> { Executable.new ['bogus'] }.must_raise SystemExit
        end.last.must_include 'usage: signore prego|pronto [tag, …]'
      end
    end

    describe '#run' do
      describe 'prego' do
        it 'prints a signature tagged with the provided tags' do
          db     = Database.new path: 'spec/fixtures/signatures.yml'
          args   = %w(prego tech programming)
          output = "// sometimes I believe compiler ignores all my comments\n"
          stdout = capture_io { Executable.new(args, db: db).run }.first
          stdout.must_equal output
        end

        it 'prints a signature based on allowed and forbidden tags' do
          db   = Database.new path: 'spec/fixtures/signatures.yml'
          args = %w(prego ~programming tech ~security)
          out  = capture_io { Executable.new(args, db: db).run }.first
          out.must_equal <<-end.dedent
            You do have to be mad to work here, but it doesn’t help.
                                                  [Gary Barnes, asr]
          end
        end
      end

      describe 'pronto' do
        let(:file) { Tempfile.new '' }

        it 'asks about signature parts and saves resulting signature' do
          input = StringIO.new <<-end.dedent
            The Wikipedia page on ADHD is like 20 pages long. That’s just cruel.

            Mark Pilgrim\n\n\n
          end

          capture_io do
            db = Database.new path: file.path
            Executable.new(%w(pronto Wikipedia ADHD), db: db).run input: input
          end.first.must_equal <<-end.dedent
            text?
            author?
            subject?
            source?
            The Wikipedia page on ADHD is like 20 pages long. That’s just cruel.
                                                                  [Mark Pilgrim]
          end

          capture_io do
            db = Database.new path: file.path
            Executable.new(%w(prego Wikipedia ADHD), db: db).run
          end.first.must_equal <<-end.dedent
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

          capture_io do
            db = Database.new path: file.path
            Executable.new(['pronto'], db: db).run input: input
          end.first.must_equal <<-end.dedent
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
