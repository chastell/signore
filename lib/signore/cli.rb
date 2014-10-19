require 'forwardable'
require_relative 'database'
require_relative 'settings'
require_relative 'sig_from_stream'

module Signore
  class CLI
    extend Forwardable

    delegate %i(action tags) => :settings

    def initialize(args = ARGV, db: Database.new)
      @settings = Settings.new(args)
      @db       = db
    end

    def run(input: $stdin)
      case action
      when 'prego'  then puts retrieve_sig
      when 'pronto' then puts create_sig_from(input)
      else abort 'usage: signore prego|pronto [tag, …]'
      end
    end

    attr_reader :db, :settings
    private     :db, :settings

    private

    def create_sig_from(input)
      SigFromStream.sig_from(input, tags: tags).tap { |sig| db << sig }
    end

    def retrieve_sig
      db.find(tags: tags)
    end
  end
end
