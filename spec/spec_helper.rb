gem 'minitest'
require 'minitest/autorun'

require 'pathname'
require 'tmpdir'

require_relative '../lib/signore'

class String
  def unindent
    gsub /^#{self[/\A\s*/]}/, ''
  end
end
