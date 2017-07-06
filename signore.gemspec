require 'English'
require 'pathname'

Gem::Specification.new do |gem|
  gem.author      = 'Piotr Szotkowski'
  gem.description = 'signore helps manage email signatures and select ' \
                    'random ones based on their tags'
  gem.email       = 'chastell@chastell.net'
  gem.homepage    = 'http://github.com/chastell/signore'
  gem.license     = 'AGPL-3.0'
  gem.name        = 'signore'
  gem.summary     = 'signore: an email signature manager/randomiser'
  gem.version     = '0.6.0'

  gem.required_ruby_version = '~> 2.3'

  gem.files       = `git ls-files -z`.split "\0"
  gem.executables = gem.files.grep(%r{^bin/}).map { |path| File.basename(path) }
  gem.test_files  = gem.files.grep(%r{^test/.*\.rb$})

  gem.cert_chain  = ['certs/chastell.pem']
  if Pathname.new($PROGRAM_NAME).basename == Pathname.new('gem')
    gem.signing_key = Pathname.new('~/.ssh/gem-private_key.pem').expand_path
  end

  gem.add_dependency 'lovely_rufus', '~> 1.0'
  gem.add_dependency 'procto',       '~> 0.0.3'

  gem.add_development_dependency 'bogus',          '~> 0.1.3'
  gem.add_development_dependency 'minitest',       '~> 5.6'
  gem.add_development_dependency 'minitest-focus', '~> 1.1'
  gem.add_development_dependency 'overcommit',     '~> 0.40.0'
  gem.add_development_dependency 'rake',           '~> 12.0'
  gem.add_development_dependency 'reek',           '~> 4.0'
  gem.add_development_dependency 'rubocop',        '~> 0.49.0'
end
