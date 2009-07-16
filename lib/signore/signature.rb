module Signore class Signature < Sequel::Model

  many_to_many :labels, :class => 'Signore::Label'

end end
