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
      puts case settings.action
           when 'prego'
             db.find(tags: tags)
           when 'pronto'
             SigFromStream.sig_from(input, tags: tags).tap { |sig| db << sig }
           else
             abort 'usage: signore prego|pronto [tag, …]'
           end
    end

    attr_reader :db, :settings
    private     :db, :settings
  end
end
