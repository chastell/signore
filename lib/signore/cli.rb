require_relative 'database'
require_relative 'settings'
require_relative 'sig_from_stream'

module Signore
  class CLI
    def initialize(args = ARGV, db: Database.new)
      @settings    = Settings.new args
      @db          = db
      valid_action = %w(prego pronto).include? settings.action
      abort 'usage: signore prego|pronto [tag, …]' unless valid_action
    end

    def run(input: $stdin)
      tags = settings.tags
      case settings.action
      when 'prego'  then puts db.find tags: tags
      when 'pronto' then puts db << SigFromStream.sig_from(input, tags: tags)
      end
    end

    attr_reader :db, :settings
    private     :db, :settings
  end
end
