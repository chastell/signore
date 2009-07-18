require 'tmpdir'

require 'lib/signore'

Signore.connect 'spec/fixtures/example.db'

def in_transaction
  Signore.db.transaction do
    yield
    raise Sequel::Rollback
  end
end
