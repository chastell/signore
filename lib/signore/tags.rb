module Signore
  Tags = Struct.new :forbidden, :required do
    def initialize(forbidden: [], required: [])
      super forbidden, required
    end
  end
end
