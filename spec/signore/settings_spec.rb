require 'tmpdir'
require_relative '../spec_helper'
require_relative '../../lib/signore/settings'
require_relative '../../lib/signore/tags'

module Signore
  describe Settings do
    describe '#action' do
      it 'is defined by the first argument' do
        Settings.new(['prego']).action.must_equal 'prego'
      end
    end

    describe '#db_path' do
      it 'defaults to $XDG_DATA_HOME/signore/signatures.yml' do
        begin
          old_xdg = ENV.delete 'XDG_DATA_HOME'
          path    = '~/.local/share/signore/signatures.yml'
          Settings.new([]).db_path.must_equal File.expand_path path
          ENV['XDG_DATA_HOME'] = Dir.mktmpdir
          default_path = "#{ENV['XDG_DATA_HOME']}/signore/signatures.yml"
          Settings.new([]).db_path.must_equal default_path
        ensure
          FileUtils.rmtree ENV['XDG_DATA_HOME']
          old_xdg ? ENV['XDG_DATA_HOME'] = old_xdg : ENV.delete('XDG_DATA_HOME')
        end
      end
    end

    describe '#tags' do
      it 'returns the forbidden and required tags' do
        tags = Tags.new forbidden: %w(tech), required: %w(en)
        Settings.new(%w(prego ~tech en)).tags.must_equal tags
      end
    end
  end
end
