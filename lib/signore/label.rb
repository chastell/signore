module Signore class Label < Sequel::Model

  many_to_many :signatures, :class => 'Signore::Signature'

end end
