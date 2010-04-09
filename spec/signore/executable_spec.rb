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
      Database.should_receive(:load_db).with 'signatures.yml'
      Executable.new ['-d', 'signatures.yml', 'prego']
    end

    it 'loads the signature database from ~/.config/signore/signatures.yml if no location specified' do
      pending if ENV['XDG_CONFIG_HOME']
      Database.should_receive(:load_db).with File.expand_path '~/.config/signore/signatures.yml'
      Executable.new ['prego']
    end

    it 'loads the signature database from $XDG_CONFIG_HOME/signore/signatures.yml if $XDG_CONFIG_HOME is set' do
      begin
        orig_config_home = ENV.delete 'XDG_CONFIG_HOME'
        ENV['XDG_CONFIG_HOME'] = Dir.tmpdir
        Database.should_receive(:load_db).with "#{ENV['XDG_CONFIG_HOME']}/signore/signatures.yml"
        Executable.new ['prego']
      ensure
        orig_config_home ? ENV['XDG_CONFIG_HOME'] = orig_config_home : ENV.delete('XDG_CONFIG_HOME')
      end
    end

  end

  context '#run' do

    it 'prints a signature tagged with the provided tags' do
      sig = mock Signature, :display => '// sometimes I believe compiler ignores all my comments'
      Signature.should_receive(:find).with({:tags => ['tech', 'programming'], :no_tags => []}).and_return sig
      Executable.new(['prego', 'tech', 'programming']).run output = StringIO.new
      output.rewind
      output.read.should == "// sometimes I believe compiler ignores all my comments\n"
    end

    it 'prints a signature based on allowed and forbidden tags' do
      sig = mock Signature, :display => 'You do have to be mad to work here, but it doesn’t help.'
      Signature.should_receive(:find).with({:tags => ['tech'], :no_tags => ['programming', 'security']}).and_return sig
      Executable.new(['prego', '~programming', 'tech', '~security']).run output = StringIO.new
      output.rewind
      output.read.should == "You do have to be mad to work here, but it doesn’t help.\n"
    end

  end

end end
