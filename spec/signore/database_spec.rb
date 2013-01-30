# encoding: UTF-8

require_relative '../spec_helper'

module Signore describe Database do
  describe '#find' do
    let(:db) { Database.new 'spec/fixtures/signatures.yml' }
    before   { srand }

    it 'returns a random signature by default' do
      srand 1981
      db.find.text.must_equal 'Amateur fighter pilot ignores orders, listens to the voices in his head and slaughters thousands.'
      srand 1979
      db.find.text.must_equal 'stay-at-home executives vs. wallstreet dads'
    end

    it 'returns a random signature if the tags are empty' do
      srand 2009
      db.find(tags: []).text.must_equal '// sometimes I believe compiler ignores all my comments'
    end

    it 'returns a random signature based on provided tags' do
      db.find(tags: ['programming']).text.must_equal '// sometimes I believe compiler ignores all my comments'
      db.find(tags: ['work']).text.must_equal        'You do have to be mad to work here, but it doesn’t help.'
    end

    it 'returns a random signature based on required and forbidden tags' do
      db.find(tags: ['tech'], no_tags: ['programming', 'security']).text.must_equal 'You do have to be mad to work here, but it doesn’t help.'
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
