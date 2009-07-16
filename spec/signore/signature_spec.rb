inside_connection do
module Signore describe Signature do

  it 'should return a proper random signature based on the provided labels' do
    Signore.db.transaction do
      Signature.find_random_by_labels(['programming']).text.should == '// sometimes I believe compiler ignores all my comments'
      Signature.find_random_by_labels(['programming', 'tech']).text.should == '// sometimes I believe compiler ignores all my comments'
      srand 1981
      Signature.find_random_by_labels(['tech']).text.should == '// sometimes I believe compiler ignores all my comments'
      srand 1979
      Signature.find_random_by_labels(['tech']).text.force_encoding('UTF-8').should == 'Bruce Schneier knows Alice and Bob’s shared secret.'
      srand
      raise Sequel::Rollback
    end
  end

end end
end
