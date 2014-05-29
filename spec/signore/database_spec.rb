require 'tempfile'
require_relative '../spec_helper'
require_relative '../../lib/signore/database'
require_relative '../../lib/signore/signature'

module Signore describe Database do
  describe '#<<' do
    it 'saves the provided signature to disk' do
      text = 'Normaliser Unix c’est comme pasteuriser le camembert.'
      file = Tempfile.new ''
      Database.new(file.path) << Signature.new(text)
      file.read.must_include text
    end
  end

  describe '#find' do
    let(:db)   { Database.new path              }
    let(:path) { 'spec/fixtures/signatures.yml' }

    it 'returns a random signature by default' do
      Database.new(path, random: Random.new(1981)).find.text
        .must_include 'Amateur fighter pilot ignores orders'
      Database.new(path, random: Random.new(2009)).find.text
        .must_include '// sometimes I believe compiler ignores all my comments'
    end

    it 'returns a random signature if the tags are empty' do
      Database.new(path, random: Random.new(2013)).find(required: []).text
        .must_equal '// sometimes I believe compiler ignores all my comments'
    end

    it 'returns a random signature based on provided tags' do
      db.find(required: ['programming']).text
        .must_equal '// sometimes I believe compiler ignores all my comments'
      db.find(required: ['work']).text
        .must_equal 'You do have to be mad to work here, but it doesn’t help.'
    end

    it 'returns a random signature based on required and forbidden tags' do
      db.find(required: %w(tech), forbidden: %w(programming security)).text
        .must_equal 'You do have to be mad to work here, but it doesn’t help.'
    end
  end
end end
