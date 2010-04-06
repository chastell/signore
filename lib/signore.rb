require 'trollop'
require 'yaml'

require_relative 'signore/executable'
require_relative 'signore/signature'

module Signore

  def self.load_db db
    FileUtils.mkpath File.dirname db                 unless File.exists? db
    File.open(db, 'w') { |file| YAML.dump [], file } unless File.exists? db
  end

end
