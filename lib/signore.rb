require 'fileutils'
require 'trollop'
require 'yaml'

YAML::ENGINE.yamler = 'psych' if defined? Psych

module Signore
  autoload :Database,   'signore/database'
  autoload :Executable, 'signore/executable'
  autoload :Signature,  'signore/signature'
  autoload :Wrapper,    'signore/wrapper'
end
