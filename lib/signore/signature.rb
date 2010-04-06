module Signore class Signature < Struct.new :text, :tags

  def self.find opts = {}
    opts = {:tags => [], :no_tags => []}.merge opts
    sigs = Signore.db.shuffle
    sigs.reject! { |sig| (sig.tags & opts[:tags]).empty? } unless opts[:tags].empty?
    sigs.reject! { |sig| not (sig.tags & opts[:no_tags]).empty? }
    sigs.first
  end

end end
