require 'fileutils'
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
