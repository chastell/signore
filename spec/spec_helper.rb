require 'tmpdir'

require 'lib/signore'

def inside_connection
  if Signore.connected?
    yield
  else
    file = "#{Dir.tmpdir}/#{rand}/signore.db"
    FileUtils.mkpath File.dirname file
    FileUtils.copy 'spec/fixtures/example.db', file
    Signore.connect file
    yield
    FileUtils.rmtree File.dirname file
  end
end
