# frozen_string_literal: true

ENV['MT_NO_EXPECTATIONS'] = 'true'
require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/focus'
require 'minitest/pride'
require 'bogus/minitest/spec'
require 'signore'

Bogus.configure { |config| config.search_modules << Signore }

class String
  def dedent
    gsub(/^#{scan(/^ +/).min}/, '')
  end
end
