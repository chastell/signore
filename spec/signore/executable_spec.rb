# encoding: UTF-8

require_relative '../spec_helper'

module Signore describe Executable do

  describe '#initialize' do

    it 'prints usage if no command is given' do
      capture_io do
        -> { Executable.new [] }.must_raise SystemExit
      end.last.must_include 'usage: signore prego|pronto [label, …]'
    end

    it 'prints usage if a bogus command is given' do
      capture_io do
        -> { Executable.new ['bogus'] }.must_raise SystemExit
      end.last.must_include 'usage: signore prego|pronto [label, …]'
    end

    it 'loads the signature database from the specified location' do
      db = MiniTest::Mock.new
      db.expect :load, nil, ['signatures.yml']
      Executable.new ['-d', 'signatures.yml', 'prego'], db
      db.verify
    end

    it 'loads the signature database from ~/.local/share/signore/signatures.yml if no location specified' do
      pending if ENV['XDG_DATA_HOME']
      db = MiniTest::Mock.new
      db.expect :load, nil, [File.expand_path('~/.local/share/signore/signatures.yml')]
      Executable.new ['prego'], db
      db.verify
    end

    it 'loads the signature database from $XDG_DATA_HOME/signore/signatures.yml if $XDG_DATA_HOME is set' do
      begin
        orig_data_home = ENV.delete 'XDG_DATA_HOME'
        ENV['XDG_DATA_HOME'] = Dir.tmpdir
        db = MiniTest::Mock.new
        db.expect :load, nil, ["#{ENV['XDG_DATA_HOME']}/signore/signatures.yml"]
        Executable.new ['prego'], db
        db.verify
      ensure
        orig_data_home ? ENV['XDG_DATA_HOME'] = orig_data_home : ENV.delete('XDG_DATA_HOME')
      end
    end

  end

  describe '#run' do

    describe 'prego' do

      it 'prints a signature tagged with the provided tags' do
        capture_io do
          Executable.new(['-d', 'spec/fixtures/signatures.yml', 'prego', 'tech', 'programming']).run
        end.first.must_equal "// sometimes I believe compiler ignores all my comments\n"
      end

      it 'prints a signature based on allowed and forbidden tags' do
        capture_io do
          Executable.new(['-d', 'spec/fixtures/signatures.yml', 'prego', '~programming', 'tech', '~security']).run
        end.first.must_include 'You do have to be mad to work here, but it doesn’t help.'
      end

    end

    describe 'pronto' do

      before do
        @path = "#{Dir.tmpdir}/#{rand}/signatures.yml"
      end

      after do
        FileUtils.rmtree File.dirname @path
      end

      it 'asks about signature parts and saves given signature with provided labels' do
        input = StringIO.new "The Wikipedia page on ADHD is like 20 pages long. That’s just cruel.\n\nMark Pilgrim\n\n\n\n"

        capture_io do
          Executable.new(['-d', @path, 'pronto', 'Wikipedia', 'ADHD']).run $stdout, input
        end.first.must_equal "text?\nauthor?\nsubject?\nsource?\nThe Wikipedia page on ADHD is like 20 pages long. That’s just cruel.\n                                                      [Mark Pilgrim]\n"

        capture_io do
          Executable.new(['-d', @path, 'prego', 'Wikipedia', 'ADHD']).run
        end.first.must_equal "The Wikipedia page on ADHD is like 20 pages long. That’s just cruel.\n                                                      [Mark Pilgrim]\n"
      end

      it 'handles multi-line signatures' do
        input = StringIO.new "‘I’ve gone through over-stressed to physical exhaustion – what’s next?’\n‘Tuesday.’\n\nSimon Burr, Kyle Hearn\n\n\n\n"

        capture_io do
          Executable.new(['-d', @path, 'pronto']).run $stdout, input
        end.first.must_equal "text?\nauthor?\nsubject?\nsource?\n‘I’ve gone through over-stressed to physical exhaustion – what’s next?’\n‘Tuesday.’\n                                               [Simon Burr, Kyle Hearn]\n"
      end

    end

  end

end end
