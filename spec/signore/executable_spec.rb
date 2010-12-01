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

    it 'loads the signature database from the specified location' do
      Database.should_receive(:load).with 'signatures.yml'
      Executable.new ['-d', 'signatures.yml', 'prego']
    end

    it 'loads the signature database from ~/.local/share/signore/signatures.yml if no location specified' do
      pending if ENV['XDG_DATA_HOME']
      Database.should_receive(:load).with File.expand_path '~/.local/share/signore/signatures.yml'
      Executable.new ['prego']
    end

    it 'loads the signature database from $XDG_DATA_HOME/signore/signatures.yml if $XDG_DATA_HOME is set' do
      begin
        orig_data_home = ENV.delete 'XDG_DATA_HOME'
        ENV['XDG_DATA_HOME'] = Dir.tmpdir
        Database.should_receive(:load).with "#{ENV['XDG_DATA_HOME']}/signore/signatures.yml"
        Executable.new ['prego']
      ensure
        orig_data_home ? ENV['XDG_DATA_HOME'] = orig_data_home : ENV.delete('XDG_DATA_HOME')
      end
    end

  end

  context '#run' do

    context 'prego' do

      it 'prints a signature tagged with the provided tags' do
        sig = mock Signature, display: '// sometimes I believe compiler ignores all my comments'
        Database.should_receive(:find).with({tags: ['tech', 'programming'], no_tags: []}).and_return sig
        Executable.new(['prego', 'tech', 'programming']).run output = StringIO.new
        output.rewind
        output.read.should == "// sometimes I believe compiler ignores all my comments\n"
      end

      it 'prints a signature based on allowed and forbidden tags' do
        sig = mock Signature, display: 'You do have to be mad to work here, but it doesn’t help.'
        Database.should_receive(:find).with({tags: ['tech'], no_tags: ['programming', 'security']}).and_return sig
        Executable.new(['prego', '~programming', 'tech', '~security']).run output = StringIO.new
        output.rewind
        output.read.should == "You do have to be mad to work here, but it doesn’t help.\n"
      end

    end

    context 'pronto' do

      before do
        @path = "#{Dir.tmpdir}/#{rand}/signatures.yml"
      end

      after do
        FileUtils.rmtree File.dirname @path
      end

      it 'asks about signature parts and saves given signature with provided labels' do
        input = StringIO.new "The Wikipedia page on ADHD is like 20 pages long. That’s just cruel.\n\nMark Pilgrim\n\n\n\n"
        Executable.new(['-d', @path, 'pronto', 'Wikipedia', 'ADHD']).run output = StringIO.new, input
        output.rewind
        output.read.should == "text?\nauthor?\nsubject?\nsource?\nThe Wikipedia page on ADHD is like 20 pages long. That’s just cruel.\n                                                      [Mark Pilgrim]\n"
        Executable.new(['-d', @path, 'prego', 'Wikipedia', 'ADHD']).run output = StringIO.new
        output.rewind
        output.read.should == "The Wikipedia page on ADHD is like 20 pages long. That’s just cruel.\n                                                      [Mark Pilgrim]\n"
      end

      it 'handles multi-line signatures' do
        input = StringIO.new "‘I’ve gone through over-stressed to physical exhaustion – what’s next?’\n‘Tuesday.’\n\nSimon Burr, Kyle Hearn\n\n\n\n"
        Executable.new(['-d', @path, 'pronto']).run output = StringIO.new, input
        output.rewind
        output.read.should == "text?\nauthor?\nsubject?\nsource?\n‘I’ve gone through over-stressed to physical exhaustion – what’s next?’\n‘Tuesday.’\n                                               [Simon Burr, Kyle Hearn]\n"
      end

    end

  end

end end
