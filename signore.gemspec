Gem::Specification.new do |gem|
  gem.name        = 'signore'
  gem.version     = '0.2.0'
  gem.summary     = 'signore: an email signature manager/randomiser'
  gem.homepage    = 'http://github.com/chastell/signore'
  gem.author      = 'Piotr Szotkowski'
  gem.email       = 'chastell@chastell.net'
  gem.license     = 'AGPL-3.0'
  gem.description = 'signore helps manage email signatures and select random ones based on their tags'

  gem.files       = `git ls-files -z`.split "\0"
  gem.executables = gem.files.grep(%r{^bin/}).map { |path| File.basename path }
  gem.test_files  = gem.files.grep %r{^spec/.*\.rb$}

  gem.add_dependency 'lovely_rufus', '~> 0.1.0'

  gem.add_development_dependency 'minitest', '~> 5.0'
  gem.add_development_dependency 'reek',     '~> 1.3'
  gem.add_development_dependency 'rubocop',  '~> 0.18.0'
end
