module Signore class Database

  def self.db
    @db
  end

  def self.load_db path
    FileUtils.mkpath File.dirname path                 unless File.exists? path
    File.open(path, 'w') { |file| YAML.dump [], file } unless File.exists? path
    @db = YAML.load_file path
  end

end end
