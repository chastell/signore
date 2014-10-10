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
      tags = settings.tags
      case settings.action
      when 'prego'
        puts db.find(tags: tags)
      when 'pronto'
        sig = SigFromStream.sig_from(input, tags: tags)
        db << sig
        puts sig
      else
        abort 'usage: signore prego|pronto [tag, …]'
      end
    end

    attr_reader :db, :settings
    private     :db, :settings
  end
end
