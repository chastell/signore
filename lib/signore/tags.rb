module Signore
  Tags = Struct.new(:forbidden, :required) do
    def initialize(forbidden: [], required: [])
      super forbidden, required
    end

    def match?(sig)
      tags = sig.tags || []
      (required & tags) == required and (forbidden & tags).empty?
    end
  end
end
