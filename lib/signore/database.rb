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
    [
      '---',
      @db.map do |sig|
        yaml = ['- !ruby/struct:Signore::Signature']
        [:text, :author, :subject, :source].map { |e| [e, sig[e]] }.select(&:last).each do |elem, string|
          yaml << "  :#{elem}: #{self.yamlify(string)}"
        end
        yaml << "  :tags: [#{sig.tags.join ', '}]" if sig.tags
        yaml
      end,
    ].join("\n") + "\n"
  end

  def self.save sig
    @db << sig
    FileUtils.mkpath File.dirname @path
    File.open(@path, 'w') { |file| file << self.min_yaml }
  end

  private

  def self.yamlify string
    case string
    when /\n/                                 then "|-\n" + string.gsub(/^ +/) { |s| ' ' * s.size }.gsub(/^/, '    ')
    when /: /, /^\s*\d*:\d*\s*$/, / #/, /^\s/ then "'#{string.gsub "'", "''"}'"
    else string
    end
  end

end end
