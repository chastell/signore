require_relative 'database'
require_relative 'settings'
require_relative 'sig_from_stream'

module Signore
  class CLI
    def initialize(args = ARGV, db: Database.new)
      @settings = Settings.new(args)
      @db       = db
    end

    def run(input: $stdin)
      case settings.action
      when 'prego'
        puts db.find(tags: settings.tags)
      when 'pronto'
        puts db << SigFromStream.sig_from(input, tags: settings.tags)
      else
        abort 'usage: signore prego|pronto [tag, …]'
      end
    end

    attr_reader :db, :settings
    private     :db, :settings
  end
end
