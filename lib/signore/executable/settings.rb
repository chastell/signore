require 'optparse'

module Signore class Executable
  Settings = Struct.new(*%i(action db_path forbidden_tags required_tags)) do
    def initialize args
      db_dir = ENV.fetch('XDG_DATA_HOME') { File.expand_path '~/.local/share' }
      self.db_path = "#{db_dir}/signore/signatures.yml"
      parse_settings args, self
      self.action = args.shift
      self.forbidden_tags, self.required_tags = args.partition do |tag|
        tag.start_with? '~'
      end
      forbidden_tags.map! { |tag| tag[1..-1] }
    end

    private

    def parse_settings args, settings
      OptionParser.new do |opts|
        opts.on '-d', '--database PATH', 'Database location' do |path|
          settings.db_path = path
        end
      end.parse! args
    end
  end
end end
