require 'tmpdir'
require_relative '../../spec_helper'
require_relative '../../../lib/signore/executable/settings'

module Signore class Executable; describe Settings do
  describe '#db_path' do
    it 'defaults to $XDG_DATA_HOME/signore/signatures.yml' do
      begin
        old_xdg = ENV.delete 'XDG_DATA_HOME'
        default_path = File.expand_path '~/.local/share/signore/signatures.yml'
        Settings.new([]).db_path.must_equal default_path
        ENV['XDG_DATA_HOME'] = Dir.mktmpdir
        default_path = "#{ENV['XDG_DATA_HOME']}/signore/signatures.yml"
        Settings.new([]).db_path.must_equal default_path
      ensure
        old_xdg ? ENV['XDG_DATA_HOME'] = old_xdg : ENV.delete('XDG_DATA_HOME')
      end
    end
  end
end end end
