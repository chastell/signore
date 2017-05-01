require 'pathname'
require 'stringio'
require 'tempfile'
require 'tmpdir'
require_relative '../test_helper'
require_relative '../../lib/signore/cli'

module Signore
  describe CLI do
    describe '#run' do
      it 'prints usage if no command is given' do
        io = capture_io { _(-> { CLI.new([]).run }).must_raise SystemExit }
        _(io.last).must_include 'usage: signore prego|pronto [tag, …]'
      end

      it 'prints usage if a bogus command is given' do
        io = capture_io { _(-> { CLI.new(['foo']).run }).must_raise SystemExit }
        _(io.last).must_include 'usage: signore prego|pronto [tag, …]'
      end

      describe 'prego' do
        let(:repo) { Repo.new(path: path)                         }
        let(:path) { Pathname.new('test/fixtures/signatures.yml') }

        it 'prints a signature tagged with the provided tags' do
          args = %w[prego tech programming]
          out  = capture_io { CLI.new(args, repo: repo).run }.first
          sig  = "// sometimes I believe compiler ignores all my comments\n"
          _(out).must_equal sig
        end

        it 'prints a signature based on allowed and forbidden tags' do
          args = %w[prego ~programming tech ~security]
          out  = capture_io { CLI.new(args, repo: repo).run }.first
          _(out).must_equal <<-end.dedent
            You do have to be mad to work here, but it doesn’t help.
                                                  [Gary Barnes, asr]
          end
        end

        it 'tells the user if no signatures are found' do
          path = Pathname.new('test/fixtures/nosignatures.yml')
          repo = Repo.new(path: path)
          args = %w[prego]
          out = capture_io { CLI.new(args, repo: repo).run }.first
          _(out).must_include 'No signatures found.'
        end

        it 'tells the user if no signatures with selected tag are found' do
          path = Pathname.new('test/fixtures/signatures.yml')
          repo = Repo.new(path: path)
          args = %w[prego esse ~percipi]
          out = capture_io { CLI.new(args, repo: repo).run }.first
          _(out).must_include 'Sadly no signatures are tagged esse ~percipi.'
        end
      end

      describe 'pronto' do
        let(:repo) { Repo.new(path: Pathname.new(Tempfile.new.path)) }

        it 'asks about signature parts and saves resulting signature' do
          input = StringIO.new <<-end.dedent
            The Wikipedia page on ADHD is like 20 pages long. That’s just cruel.

            Mark Pilgrim\n\n\n
          end
          args = %w[pronto Wikipedia ADHD]
          out  = capture_io { CLI.new(args, repo: repo).run input: input }.first
          _(out).must_equal <<-end.dedent

            text?

            author?

            subject?

            source?
            The Wikipedia page on ADHD is like 20 pages long. That’s just cruel.
                                                                  [Mark Pilgrim]
          end
          args = %w[prego Wikipedia ADHD]
          out  = capture_io { CLI.new(args, repo: repo).run }.first
          _(out).must_equal <<-end.dedent
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
          io = capture_io { CLI.new(['pronto'], repo: repo).run input: input }
          _(io.first).must_equal <<-end.dedent

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
