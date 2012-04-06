Gem::Specification.new do |gem|
  gem.name     = 'signore'
  gem.version  = '0.1.2'
  gem.summary  = 'signore: an email signature manager/randomiser'
  gem.homepage = 'http://github.com/chastell/signore'
  gem.author   = 'Piotr Szotkowski'
  gem.email    = 'chastell@chastell.net'

  gem.files       = `git ls-files -z`.split "\0"
  gem.executables = Dir['bin/*'].map { |d| d.split '/' }.map &:last
  gem.test_files  = Dir['spec/**/*.rb']

  gem.add_dependency 'lovely-rufus', '>= 0.0.2'
  gem.add_dependency 'trollop'
  gem.add_development_dependency 'minitest', '>= 2.12'
  gem.add_development_dependency 'rake'
end
