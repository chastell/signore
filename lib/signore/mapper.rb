# frozen_string_literal: true

require_relative 'signature'

module Signore
  module Mapper
    module_function

    def from_h(hash)
      Signature.new(hash.map { |key, value| [key.to_sym, value] }.to_h)
    end

    def to_h(signature)
      signature.to_h
    end
  end
end
