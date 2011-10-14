# encoding: UTF-8

require_relative '../spec_helper'

module Signore describe Executable do

  describe '#initialize' do

    it 'prints usage if no command is given' do
      stderr = capture_io { -> { Executable.new [] }.must_raise SystemExit }.last
      stderr.must_include 'usage: signore prego|pronto [label, …]'
    end

    it 'prints usage if a bogus command is given' do
      stderr = capture_io { -> { Executable.new ['bogus'] }.must_raise SystemExit }.last
      stderr.must_include 'usage: signore prego|pronto [label, …]'
    end

    it 'loads the signature database from the specified location' do
      db_class = MiniTest::Mock.new
      db_class.expect :new, nil, ['signatures.yml']
      Executable.new ['-d', 'signatures.yml', 'prego'], db_class
      db_class.verify
    end

    it 'loads the signature database from ~/.local/share/signore/signatures.yml if no location specified' do
      pending if ENV['XDG_DATA_HOME']
      db_class = MiniTest::Mock.new
      db_class.expect :new, nil, [File.expand_path('~/.local/share/signore/signatures.yml')]
      Executable.new ['prego'], db_class
      db_class.verify
    end

    it 'loads the signature database from $XDG_DATA_HOME/signore/signatures.yml if $XDG_DATA_HOME is set' do
      begin
        orig_data_home = ENV.delete 'XDG_DATA_HOME'
        ENV['XDG_DATA_HOME'] = Dir.tmpdir
        db_class = MiniTest::Mock.new
        db_class.expect :new, nil, ["#{ENV['XDG_DATA_HOME']}/signore/signatures.yml"]
        Executable.new ['prego'], db_class
        db_class.verify
      ensure
        orig_data_home ? ENV['XDG_DATA_HOME'] = orig_data_home : ENV.delete('XDG_DATA_HOME')
      end
    end

  end

  describe '#run' do

    describe 'prego' do

      it 'prints a signature tagged with the provided tags' do
        stdout = capture_io { Executable.new(['-d', 'spec/fixtures/signatures.yml', 'prego', 'tech', 'programming']).run }.first
        stdout.must_equal <<-END.dedent
          // sometimes I believe compiler ignores all my comments
        END
      end

      it 'prints a signature based on allowed and forbidden tags' do
        stdout = capture_io { Executable.new(['-d', 'spec/fixtures/signatures.yml', 'prego', '~programming', 'tech', '~security']).run }.first
        stdout.must_equal <<-END.dedent
          You do have to be mad to work here, but it doesn’t help.
                                                [Gary Barnes, asr]
        END
      end

    end

    describe 'pronto' do

      before do
        @file = Tempfile.new ''
      end

      it 'asks about signature parts and saves given signature with provided labels' do
        input = StringIO.new <<-END.dedent
          The Wikipedia page on ADHD is like 20 pages long. That’s just cruel.\n
          Mark Pilgrim\n\n\n
        END

        stdout = capture_io { Executable.new(['-d', @file.path, 'pronto', 'Wikipedia', 'ADHD']).run input }.first
        stdout.must_equal <<-END.dedent
          text?
          author?
          subject?
          source?
          The Wikipedia page on ADHD is like 20 pages long. That’s just cruel.
                                                                [Mark Pilgrim]
        END

        stdout = capture_io { Executable.new(['-d', @file.path, 'prego', 'Wikipedia', 'ADHD']).run }.first
        stdout.must_equal <<-END.dedent
          The Wikipedia page on ADHD is like 20 pages long. That’s just cruel.
                                                                [Mark Pilgrim]
        END
      end

      it 'handles multi-line signatures' do
        input = StringIO.new <<-END.dedent
          ‘I’ve gone through over-stressed to physical exhaustion – what’s next?’
          ‘Tuesday.’\n
          Simon Burr, Kyle Hearn\n\n\n
        END

        stdout = capture_io { Executable.new(['-d', @file.path, 'pronto']).run input }.first
        stdout.must_equal <<-END.dedent
          text?
          author?
          subject?
          source?
          ‘I’ve gone through over-stressed to physical exhaustion – what’s next?’
          ‘Tuesday.’
                                                         [Simon Burr, Kyle Hearn]
        END
      end

    end

  end

end end
