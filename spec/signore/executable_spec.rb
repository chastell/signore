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
      Signore.should_receive(:load_db).with 'signatures.yml'
      Executable.new ['-d', 'signatures.yml', 'prego']
    end

    it 'loads the signature database from ~/.config/signore/signatures.yml if no location specified' do
      pending if ENV['XDG_CONFIG_HOME']
      Signore.should_receive(:load_db).with File.expand_path '~/.config/signore/signatures.yml'
      Executable.new ['prego']
    end

    it 'loads the signature database from $XDG_CONFIG_HOME/signore/signatures.yml if $XDG_CONFIG_HOME is set' do
      begin
        orig_config_home = ENV.delete 'XDG_CONFIG_HOME'
        ENV['XDG_CONFIG_HOME'] = Dir.tmpdir
        Signore.should_receive(:load_db).with "#{ENV['XDG_CONFIG_HOME']}/signore/signatures.yml"
        Executable.new ['prego']
      ensure
        orig_config_home ? ENV['XDG_CONFIG_HOME'] = orig_config_home : ENV.delete('XDG_CONFIG_HOME')
      end
    end

  end

end end
