require 'optparse'

module Signore class Executable; class Settings
  attr_reader :action, :db_path, :forbidden_tags, :required_tags

  def initialize args
    @db_path = get_db_path_from args
    @action  = args.shift
    @forbidden_tags, @required_tags = args.partition do |tag|
      tag.start_with? '~'
    end
    forbidden_tags.map! { |tag| tag[1..-1] }
  end

  private

  def db_dir
    ENV.fetch('XDG_DATA_HOME') { File.expand_path '~/.local/share' }
  end

  def get_db_path_from args
    db_path = "#{db_dir}/signore/signatures.yml"
    OptionParser.new do |opts|
      opts.on '-d', '--database PATH', 'Database location' do |path|
        db_path = path
      end
    end.parse! args
    db_path
  end
end end end
