require 'forwardable'
require_relative 'repo'
require_relative 'settings'
require_relative 'sig_from_stream'

module Signore
  class CLI
    extend Forwardable

    delegate %i(action tags) => :settings

    def initialize(args = ARGV, repo: Repo.new)
      @settings = Settings.new(args)
      @repo     = repo
    end

    def run(input: $stdin)
      case action
      when 'prego'  then prego
      when 'pronto' then puts create_sig_from(input)
      else abort 'usage: signore prego|pronto [tag, …]'
      end
    end

    private

    attr_reader :repo, :settings

    def prego
      sig = repo.find(tags: tags)
      puts case
           when repo.empty? then 'No signatures found.'
           when sig.empty?  then "Sadly no signatures are tagged #{tags}."
           else sig
           end
    end

    def create_sig_from(input)
      SigFromStream.call(input, tags: tags).tap { |sig| repo << sig }
    end
  end
end
