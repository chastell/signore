require_relative '../spec_helper'

module Signore describe Database do
  describe '#find' do
    let(:db)   { Database.new path              }
    let(:path) { 'spec/fixtures/signatures.yml' }

    it 'returns a random signature by default' do
      Database.new(path).find(random: Random.new(1981)).text
        .must_include 'Amateur fighter pilot ignores orders'
      Database.new(path).find(random: Random.new(2009)).text
        .must_include '// sometimes I believe compiler ignores all my comments'
    end

    it 'returns a random signature if the tags are empty' do
      Database.new(path).find(required_tags: [], random: Random.new(2013)).text
        .must_equal '// sometimes I believe compiler ignores all my comments'
    end

    it 'returns a random signature based on provided tags' do
      db.find(required_tags: ['programming']).text
        .must_equal '// sometimes I believe compiler ignores all my comments'
      db.find(required_tags: ['work']).text
        .must_equal 'You do have to be mad to work here, but it doesn’t help.'
    end

    it 'returns a random signature based on required and forbidden tags' do
      db.find(required_tags: ['tech'], forbidden_tags: ['programming', 'security']).text
        .must_equal 'You do have to be mad to work here, but it doesn’t help.'
    end
  end

  describe '#<<' do
    it 'saves the provided signature to disk' do
      file = Tempfile.new ''
      db   = Database.new file.path
      db  << Signature.new('Normaliser Unix c’est comme pasteuriser le camembert.')
      file.read.must_include 'Normaliser Unix c’est comme pasteuriser le camembert.'
    end
  end
end end
