module Signore class Database

  def self.db
    @db
  end

  def self.find opts = {}
    opts = {:tags => [], :no_tags => []}.merge opts
    @db
      .select { |sig| opts[:tags].all?    { |tag| sig.tagged_with? tag } }
      .reject { |sig| opts[:no_tags].any? { |tag| sig.tagged_with? tag } }
      .shuffle.first
  end

  def self.load path
    FileUtils.mkpath File.dirname path                 unless File.exists? path
    File.open(path, 'w') { |file| YAML.dump [], file } unless File.exists? path
    @db = YAML.load_file path
  end

end end
