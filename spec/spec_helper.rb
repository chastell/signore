require 'bundler/setup'
require 'minitest/autorun'
require 'pathname'
require 'tempfile'
require 'tmpdir'

require 'signore'

class String
  def dedent
    gsub(/^#{self[/\A\s*/]}/, '')
  end
end
