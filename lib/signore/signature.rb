module Signore class Signature < Struct.new :text

  def self.find
    Signore.db.sort_by { rand }.first
  end

end end
