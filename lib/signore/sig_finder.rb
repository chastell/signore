class SigFinder
  def initialize sigs, random: Random.new
    @random = random
    @sigs   = sigs
  end

  def find_tagged forbidden_tags: [], required_tags: []
    sigs
      .select { |sig| required_tags.all?  { |tag| sig.tagged_with? tag } }
      .reject { |sig| forbidden_tags.any? { |tag| sig.tagged_with? tag } }
      .sample random: random
  end

  attr_reader :random, :sigs
  private     :random, :sigs
end
