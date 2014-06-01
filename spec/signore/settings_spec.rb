require 'tmpdir'
require_relative '../spec_helper'
require_relative '../../lib/signore/settings'

module Signore describe Settings do
  describe '#action' do
    it 'is defined by the first argument' do
      Settings.new(['prego']).action.must_equal 'prego'
    end
  end

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

    it 'is parsed from -d/--database PATH' do
      Settings.new(%w(-d foo)).db_path.must_equal 'foo'
    end
  end

  describe '#tags' do
    it 'returns the forbidden and required tags' do
      Settings.new(%w(prego ~tech en)).tags
        .must_equal Settings::Tags.new %w(tech), %w(en)
    end
  end
end end
