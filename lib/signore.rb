def self.warn_off
  orig_verbose = $VERBOSE
  $VERBOSE = false
  yield
ensure
  $VERBOSE = orig_verbose
end

warn_off { require 'private_attr' }

Class.include PrivateAttr

require_relative 'signore/cli'
