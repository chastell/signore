require 'pathname'
require 'tmpdir'
require_relative '../test_helper'
require_relative '../../lib/signore/settings'
require_relative '../../lib/signore/tags'

module Signore
  describe Settings do
    describe '#action' do
      it 'is defined by the first argument' do
        _(Settings.new(['prego']).action).must_equal 'prego'
      end
    end

    describe '#repo_path' do
      it 'honours XDG_DATA_HOME if it’s set' do
        begin
          old_xdg = ENV.delete('XDG_DATA_HOME')
          ENV['XDG_DATA_HOME'] = Dir.mktmpdir
          path = "#{ENV['XDG_DATA_HOME']}/signore/signatures.yml"
          _(Settings.new.repo_path).must_equal Pathname.new(path)
        ensure
          FileUtils.rmtree ENV['XDG_DATA_HOME']
          old_xdg ? ENV['XDG_DATA_HOME'] = old_xdg : ENV.delete('XDG_DATA_HOME')
        end
      end

      it 'defaults XDG_DATA_HOME to ~/.local/share if it’s not set' do
        begin
          old_xdg = ENV.delete('XDG_DATA_HOME')
          path    = File.expand_path('~/.local/share/signore/signatures.yml')
          _(Settings.new.repo_path).must_equal Pathname.new(path)
        ensure
          ENV['XDG_DATA_HOME'] = old_xdg if old_xdg
        end
      end
    end

    describe '#tags' do
      it 'returns the forbidden and required tags' do
        tags = Tags.new(forbidden: %w[tech], required: %w[en])
        _(Settings.new(%w[prego ~tech en]).tags).must_equal tags
      end

      it 'doesn’t blow up on empty args' do
        _(Settings.new([]).tags).must_equal Tags.new
      end
    end
  end
end
