module Signore class Signature < Struct.new :text, :tags

  def self.find opts = {:tags => []}
    sigs = Signore.db.dup
    sigs.reject! { |sig| (sig.tags & opts[:tags]).empty? } unless opts[:tags].empty?
    sigs.sort_by { rand }.first
  end

end end
