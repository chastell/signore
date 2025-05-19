module Signore
  Tags = Struct.new(:forbidden, :required) do
    def initialize(forbidden: [], required: [])
      super(forbidden, required)
    end

    def match?(sig_tags)
      (required & sig_tags) == required and not forbidden.intersect?(sig_tags) # rubocop:disable Style/BitwisePredicate
    end

    def to_s
      (required + forbidden.map { |tag| "~#{tag}" }).join(' ')
    end
  end
end
