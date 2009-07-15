describe Signore do

  before do
    @file = "#{Dir.tmpdir}/#{rand}/signore.db"
  end

  after do
    FileUtils.rmtree File.dirname @file
  end

  it 'should setup the database connection, creating the database and migrating it to the current schema if required' do
    File.exists?(@file).should be_false
    Signore.connect @file
    File.exists?(@file).should be_true
    Sequel.amalgalite(@file).tables.should include :signatures
  end

end
