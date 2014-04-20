require_relative '../../spec_helper'
require_relative '../../../lib/signore/executable/settings'

module Signore class Executable; describe Settings do
  describe '#db_path' do
    it 'defaults to ~/.local/share/signore/signatures.yml' do
      begin
        xdg_data_home = ENV.delete 'XDG_DATA_HOME'
        default_path = File.expand_path '~/.local/share/signore/signatures.yml'
        Settings.new([]).db_path.must_equal default_path
      ensure
        ENV['XDG_DATA_HOME'] = xdg_data_home
      end
    end
  end
end end end
