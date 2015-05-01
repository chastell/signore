module Signore
  Tags = Struct.new(:forbidden, :required) do
    def initialize(forbidden: [], required: [])
      super forbidden, required
    end

    def match?(sig_tags)
      sig_tags ||= []
      (required & sig_tags) == required and (forbidden & sig_tags).empty?
    end
  end
end
