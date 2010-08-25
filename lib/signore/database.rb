# encoding: UTF-8

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
    @path = path
    @db = File.exists?(@path) ? YAML.load_file(@path) : []
  end

  def self.min_yaml
    @db.to_yaml.gsub /^  (author|source|subject|tags): !!null \n/, ''
  end

  def self.save sig
    @db << sig
    FileUtils.mkpath File.dirname @path
    File.open(@path, 'w') { |file| file << self.min_yaml }
  end

end end
