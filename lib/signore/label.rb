module Signore class Label < Sequel::Model

  many_to_many :signatures

end end
