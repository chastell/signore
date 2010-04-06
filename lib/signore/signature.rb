module Signore class Signature < Struct.new :text, :tags

  def self.find opts = {}
    if opts[:tags]
      sigs = Signore.db.reject { |sig| (sig.tags & opts[:tags]).empty? }
    else
      sigs = Signore.db
    end
    sigs.sort_by { rand }.first
  end

end end
