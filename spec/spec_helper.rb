require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/pride'
require 'signore'

class String
  def dedent
    gsub(/^#{self[/\A\s*/]}/, '')
  end
end
