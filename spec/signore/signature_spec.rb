# encoding: UTF-8

module Signore describe Signature do

  context '.find' do

    it 'returns a random signature by default' do
      Signore.load_db 'spec/fixtures/signatures.yml'
      srand 1981
      Signature.find.text.should == '// sometimes I believe compiler ignores all my comments'
      srand 1979
      Signature.find.text.should == 'You do have to be mad to work here, but it doesn’t help.'
    end

  end

end end
