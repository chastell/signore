describe Signore do

  context '.db' do

    it 'returns the signature database loaded by .load_db' do
      db = "#{Dir.tmpdir}/#{rand}/signatures.yml"
      Signore.load_db db
      Signore.db.should == []
    end

  end

  context '.load_db' do

    it 'creates an empty signature database if it does not exist' do
      db = "#{Dir.tmpdir}/#{rand}/signatures.yml"
      File.exists?(db).should be_false
      Signore.load_db db
      File.read(db).should == [].to_yaml
    end

  end

end
