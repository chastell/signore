require_relative '../test_helper'
require_relative '../../lib/signore/signature'
require_relative '../../lib/signore/tags'

module Signore
  describe Tags do
    describe '#match?' do
      it 'is a predicate whether the Signature matches the Tags' do
        assert Tags.new.match?(Signature.new)
        assert Tags.new(forbidden: %w(fnord)).match?(Signature.new)
        sig = Signature.new(tags: %w(programming tech))
        assert Tags.new.match?(sig)
        assert Tags.new(required: %w(programming)).match?(sig)
        assert Tags.new(required: %w(programming tech)).match?(sig)
        refute Tags.new(required: %w(programming tech Ruby)).match?(sig)
        refute Tags.new(forbidden: %w(programming)).match?(sig)
        refute Tags.new(forbidden: %w(tech), required: %w(tech)).match?(sig)
      end
    end
  end
end
