require 'fileutils'
require 'trollop'
require 'yaml'

YAML::ENGINE.yamler = 'psych' if defined? Psych

require_relative 'signore/database'
require_relative 'signore/executable'
require_relative 'signore/signature'
require_relative 'signore/wrapper'
