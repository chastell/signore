describe Signore do

  context '.load_db' do

    it 'creates an empty signature database if it does not exist' do
      db = "#{Dir.tmpdir}/#{rand}/signatures.yml"
      File.exists?(db).should be_false
      Signore.load_db db
      File.read(db).should == [].to_yaml
    end

  end

end
