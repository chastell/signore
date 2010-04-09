module Signore describe Database do

  before do
    @db = "#{Dir.tmpdir}/#{rand}/signatures.yml"
  end

  after do
    FileUtils.rmtree File.dirname @db
  end

  context '.db' do

    it 'returns the signature database loaded by .load' do
      Database.load @db
      Database.db.should == []
    end

  end

  context '.load' do

    it 'creates an empty signature database if it does not exist' do
      File.exists?(@db).should be_false
      Database.load @db
      File.read(@db).should == [].to_yaml
    end

  end

end end
