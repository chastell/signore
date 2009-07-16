describe Signore do

  before do
    @file = "#{Dir.tmpdir}/#{rand}/signore.db"
  end

  after do
    FileUtils.rmtree File.dirname @file
  end

  it 'should setup the database connection, creating the database and migrating it to the current schema if required' do
    pending if Signore.connected?
    File.exists?(@file).should be_false
    Signore.should_not be_connected
    Signore.connect @file
    Signore.should be_connected
    File.exists?(@file).should be_true
    Signore.db.tables.should include :signatures
  end

end
