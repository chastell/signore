require 'fileutils'
require 'sequel'
require 'sequel/extensions/migration'
require 'trollop'

module Signore

  def self.connect file
    return if connected?
    # FIXME: make this optionally work with Amalgalite
    @db = Sequel.sqlite file
    unless File.exists? file
      FileUtils.mkpath File.dirname file
      Sequel::Migrator.apply @db, "#{File.dirname __FILE__}/signore/migrations"
    end
    require_relative 'signore/label'
    require_relative 'signore/signature'
  end

  def self.connected?
    not @db.nil?
  end

  def self.db
    @db
  end

end

require_relative 'signore/executable'
