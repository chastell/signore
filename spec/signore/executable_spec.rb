# encoding: UTF-8

module Signore describe Executable do

  context '#initialize' do

    before do
      $stderr = StringIO.new
    end

    after do
      $stderr = STDERR
    end

    def stderr
      $stderr.rewind
      $stderr.read
    end

    it 'prints usage if no command is given' do
      lambda { Executable.new([]) }.should raise_error SystemExit
      stderr.should match /usage: signore prego\|pronto \[label, …\]/
    end

    it 'prints usage if a bogus command is given' do
      lambda { Executable.new(['bogus']) }.should raise_error SystemExit
      stderr.should match /usage: signore prego\|pronto \[label, …\]/
    end

  end

end end
