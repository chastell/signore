# encoding: UTF-8

module Signore class Database

  def self.db
    @db
  end

  def self.find opts = {}
    opts = {tags: [], no_tags: []}.merge opts
    @db
      .select { |sig| opts[:tags].all?    { |tag| sig.tagged_with? tag } }
      .reject { |sig| opts[:no_tags].any? { |tag| sig.tagged_with? tag } }
      .shuffle.first
  end

  def self.load path
    @path = path
    @db = YAML.load_file(@path) rescue nil
    @db ||= []
  end

  def self.save sig
    @db << sig
    FileUtils.mkpath File.dirname @path
    File.open(@path, 'w') { |file| file << @db.to_yaml }
  end

end end
