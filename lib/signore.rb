require 'fileutils'
require 'trollop'
require 'yaml'

require_relative 'signore/executable'
require_relative 'signore/signature'
require_relative 'signore/wrapper'

module Signore

  def self.db
    @db
  end

  def self.load_db db
    FileUtils.mkpath File.dirname db                 unless File.exists? db
    File.open(db, 'w') { |file| YAML.dump [], file } unless File.exists? db
    @db = YAML.load_file db
  end

end
