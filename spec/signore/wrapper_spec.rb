module Signore describe Wrapper do

  describe '#display' do

    it 'returns properly wrapped signature (with possible meta information)' do
      YAML.load_file('spec/fixtures/wrapper.yml').each do |sample|
        Wrapper.new(sample[:text], sample[:meta]).display.should == sample[:wrapped]
      end
    end

  end

end end
