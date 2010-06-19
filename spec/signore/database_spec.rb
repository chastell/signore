# encoding: UTF-8

module Signore describe Database do

  before do
    @path = "#{Dir.tmpdir}/#{rand}/signatures.yml"
  end

  after do
    FileUtils.rmtree File.dirname @path
  end

  context '.db' do

    it 'returns the signature database loaded by .load' do
      Database.load @path
      Database.db.should == []
    end

  end

  context '.find' do

    before do
      srand
      Database.load 'spec/fixtures/signatures.yml'
    end

    it 'returns a random signature by default' do
      srand 1981
      Database.find.text.should == 'Amateur fighter pilot ignores orders, listens to the voices in his head and slaughters thousands.'
      srand 1979
      Database.find.text.should == 'stay-at-home executives vs. wallstreet dads'
    end

    it 'returns a random signature if the tags are empty' do
      srand 2009
      Database.find(:tags => []).text.should == '// sometimes I believe compiler ignores all my comments'
    end

    it 'returns a random signature based on provided tags' do
      Database.find(:tags => ['programming']).text.should == '// sometimes I believe compiler ignores all my comments'
      Database.find(:tags => ['work']).text.should        == 'You do have to be mad to work here, but it doesn’t help.'
    end

    it 'returns a random signature based on required and forbidden tags' do
      Database.find(:tags => ['tech'], :no_tags => ['programming', 'security']).text.should == 'You do have to be mad to work here, but it doesn’t help.'
    end

  end

  context '.load' do

    it 'creates an empty signature database if it does not exist, but does not save it' do
      File.exists?(@path).should be_false
      Database.load @path
      Database.db.should == []
      File.exists?(@path).should be_false
    end

  end

  context '.save' do

    it 'saves the provided signature to disk' do
      Database.load @path
      sig = Signature.new 'Normaliser Unix c’est comme pasteuriser le camembert.'
      Database.save sig
      File.read(@path).should == "---\n- !ruby/struct:Signore::Signature\n  :text: Normaliser Unix c’est comme pasteuriser le camembert.\n"
    end

  end

  context '.min_yaml' do

    it 'returns the minimal YAML representation of the signature database' do
      Database.load 'spec/fixtures/min_yaml.yml'
      Database.min_yaml.should == File.read('spec/fixtures/min_yaml.yml')
    end

    it 'escapes initial spaces in multi-line signatures' do
      tng = "   ← space\nthe final\nfrontier"
      Database.load @path
      Database.save Signature.new tng
      Database.load @path
      Database.find.display.should == tng
    end

  end

end end
