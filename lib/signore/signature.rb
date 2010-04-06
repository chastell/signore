module Signore class Signature < Struct.new :text, :tags

  def self.find opts = {:tags => []}
    if opts[:tags].empty?
      sigs = Signore.db
    else
      sigs = Signore.db.reject { |sig| (sig.tags & opts[:tags]).empty? }
    end
    sigs.sort_by { rand }.first
  end

end end
