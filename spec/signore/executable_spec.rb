module Signore describe Executable do

  before do
    @orig_stderr = $stderr
    $stderr = StringIO.new
  end

  after do
    $stderr = @orig_stderr
  end

  def stderr
    $stderr.rewind
    $stderr.read
  end

  it 'should print usage if no command was given' do
    lambda { Executable.new([]) }.should raise_error SystemExit
    stderr.should match /usage: signore prego\|pronto \[label, …\]/
  end

  it 'should print usage if a wrong command was given' do
    lambda { Executable.new(['bogus']) }.should raise_error SystemExit
    stderr.should match /usage: signore prego\|pronto \[label, …\]/
  end

  it 'should connect to the database provided with the --database option, defaulting to ~/.signore/signore.db' do
    Signore.should_receive(:connect).with 'signore.db'
    Executable.new ['-d', 'signore.db', 'prego']
    Signore.should_receive(:connect).with File.expand_path('~/.signore/signore.db')
    Executable.new ['prego']
  end

  it 'should print a random signature based on the provided labels' do
    sig = mock Signature
    Signore.should_receive :connect # added only so that we don’t actually connect for this spec
    Signature.should_receive(:find_random_by_labels).with(['tech', 'programming']).and_return sig
    sig.should_receive(:display).and_return '// sometimes I believe compiler ignores all my comments'
    Executable.new(['prego', 'tech', 'programming']).run output = StringIO.new
    output.rewind
    output.read.should == "// sometimes I believe compiler ignores all my comments\n"
  end

end end
