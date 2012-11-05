gem 'minitest'
require 'minitest/autorun'

require 'pathname'
require 'tempfile'
require 'tmpdir'

require_relative '../lib/signore'

class String
  def dedent
    gsub(/^#{self[/\A\s*/]}/, '')
  end
end
