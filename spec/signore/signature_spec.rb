# encoding: UTF-8

module Signore describe Signature do

  it 'should return a proper random signature based on the provided labels' do
    lambda { Signature.find_random_by_labels([]) }.should_not raise_error
    lambda { Signature.find_random_by_labels(['foo']) }.should_not raise_error
    Signature.find_random_by_labels(['programming']).text.should == '// sometimes I believe compiler ignores all my comments'
    Signature.find_random_by_labels(['programming', 'tech']).text.should == '// sometimes I believe compiler ignores all my comments'
    srand 1981
    Signature.find_random_by_labels(['tech']).text.should == '// sometimes I believe compiler ignores all my comments'
    srand 1979
    Signature.find_random_by_labels(['tech']).text.should == 'Bruce Schneier knows Alice and Bob’s shared secret.'
    srand
  end

  it 'should properly display signatures with (and without) author/source' do
    Signature[1].display.should == '// sometimes I believe compiler ignores all my comments'
    Signature[2].display.should == "stay-at-home executives vs. wallstreet dads\n                                     [kodz]"
    Signature[3].display.should == "You do have to be mad to work here, but it doesn’t help.\n                                      [Gary Barnes, asr]"
    Signature[4].display.should == "Bruce Schneier knows Alice and Bob’s shared secret.\n                             [Bruce Schneier Facts]"
    Signature[5].display.should == "She was good at playing abstract confusion in\nthe same way a midget is good at being short.\n              [Clive James on Marilyn Monroe]"
  end

  it 'should properly create a signature with the provided labels, setting author/source to NULL if empty' do
    in_transaction do
      random = rand.to_s
      sig = Signature.create_with_labels :text => 'Nostalgia is a symptom of amnesia.', :author => 'Fletch', :source => 'Oh Word', :labels => ['life', random]
      sig.display.should == "Nostalgia is a symptom of amnesia.\n                 [Fletch, Oh Word]"
      Signature.find_random_by_labels(['life', random]).should == sig
      sig = Signature.create_with_labels :text => 'Sleep is just a drug.', :author => '', :source => ''
      sig.display.should == 'Sleep is just a drug.'
    end
  end

  it 'should use the Wrapper class for wrapping signatures' do
    in_transaction do
      wrapper = mock Wrapper
      Wrapper.should_receive(:new).with('Nostalgia is a symptom of amnesia.', 'Fletch, Oh Word').and_return wrapper
      wrapper.should_receive(:display).and_return 'Nostalgia is a symptom of amnesia. [Fletch, Oh Word]'
      sig = Signature.create :text => 'Nostalgia is a symptom of amnesia.', :author => 'Fletch', :source => 'Oh Word'
      sig.display.should == 'Nostalgia is a symptom of amnesia. [Fletch, Oh Word]'
    end
  end

end end
