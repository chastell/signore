module Signore class Signature < Struct.new :text, :tags

  def self.find opts = {}
    opts = {:tags => [], :no_tags => []}.merge opts
    sigs = Signore.db.dup
    sigs.reject! { |sig| (sig.tags & opts[:tags]).empty? } unless opts[:tags].empty?
    sigs.reject! { |sig| not (sig.tags & opts[:no_tags]).empty? }
    sigs.sort_by { rand }.first
  end

end end
