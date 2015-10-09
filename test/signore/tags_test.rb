require_relative '../test_helper'
require_relative '../../lib/signore/tags'

module Signore
  describe Tags do
    describe '#match?' do
      it 'is a predicate whether the Tags match the given list of tags' do
        tags = %w(programming tech)
        assert Tags.new.match?(nil)
        assert Tags.new(forbidden: %w(fnord)).match?(nil)
        assert Tags.new.match?(tags)
        assert Tags.new(required: %w(programming)).match?(tags)
        assert Tags.new(required: %w(programming tech)).match?(tags)
        refute Tags.new(required: %w(programming tech Ruby)).match?(tags)
        refute Tags.new(forbidden: %w(programming)).match?(tags)
        refute Tags.new(forbidden: %w(tech), required: %w(tech)).match?(tags)
      end
    end

    describe '#to_s' do
      it 'returns a CLI-like representation of the Tags' do
        _(Tags.new.to_s).must_equal ''
        _(Tags.new(required: %w(tech)).to_s).must_equal 'tech'
        _(Tags.new(forbidden: %w(fnord)).to_s).must_equal '~fnord'
        _(Tags.new(forbidden: %w(fnord), required: %w(tech)).to_s)
          .must_equal 'tech ~fnord'
      end
    end
  end
end
