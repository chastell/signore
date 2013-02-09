Gem::Specification.new do |gem|
  gem.name     = 'signore'
  gem.version  = '0.1.2'
  gem.summary  = 'signore: an email signature manager/randomiser'
  gem.homepage = 'http://github.com/chastell/signore'
  gem.author   = 'Piotr Szotkowski'
  gem.email    = 'chastell@chastell.net'

  gem.files       = `git ls-files -z`.split "\0"
  gem.executables = gem.files.grep(%r{^bin/}).map { |path| File.basename path }
  gem.test_files  = gem.files.grep %r{^spec/.*\.rb$}

  gem.add_dependency 'lovely-rufus', '>= 0.0.2'

  gem.add_development_dependency 'minitest', '~> 4.0'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rb-inotify'
  gem.add_development_dependency 'rerun'
end
