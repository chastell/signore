class SigFinder
  def initialize sigs, random: Random.new
    @random = random
    @sigs   = sigs
  end

  def find_tagged forbidden: [], required: []
    sigs
      .select { |sig| required.all?  { |tag| sig.tagged_with? tag } }
      .reject { |sig| forbidden.any? { |tag| sig.tagged_with? tag } }
      .sample random: random
  end

  attr_reader :random, :sigs
  private     :random, :sigs
end
