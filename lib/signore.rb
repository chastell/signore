require 'sequel'
require 'sequel/extensions/migration'
require 'trollop'

module Signore

  def self.connect file
    return if connected?
    db = Sequel.amalgalite file
    unless File.exists? file
      FileUtils.mkpath File.dirname file
      Sequel::Migrator.apply db, "#{File.dirname __FILE__}/signore/migrations"
    end
    @connected = true
  end

  def self.connected?
    @connected || false
  end

end

require_relative 'signore/executable'
