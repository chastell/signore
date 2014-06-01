require 'optparse'

module Signore class Settings
  Tags = Struct.new :forbidden, :required do
    def initialize forbidden = [], required = []
      self.forbidden = forbidden
      self.required  = required
    end
  end

  attr_reader :db_path

  def initialize args
    @args    = args
    db_dir   = ENV.fetch('XDG_DATA_HOME') { File.expand_path '~/.local/share' }
    @db_path = "#{db_dir}/signore/signatures.yml"
    extract_options_from args
  end

  def action
    args.first
  end

  def tags
    Tags.new forbidden, required
  end

  attr_reader :args
  private     :args

  private

  def extract_options_from args
    OptionParser.new do |opts|
      opts.on '-d', '--database PATH', String, 'Database location' do |path|
        @db_path = path
      end
    end.parse! args
  end

  def forbidden
    args[1..-1].select { |tag| tag.start_with? '~' }.map { |tag| tag[1..-1] }
  end

  def required
    args[1..-1].reject { |tag| tag.start_with? '~' }
  end
end end
