require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/pride'
require 'pathname'
require 'tempfile'
require 'tmpdir'

require 'signore'

class String
  def dedent
    gsub(%r(^#{self[/\A\s*/]}), '')
  end
end
