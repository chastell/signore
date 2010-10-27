Gem::Specification.new do |gem|
  gem.name     = 'signore'
  gem.version  = '0.0.0'
  gem.summary  = 'signore: an email signature manager/randomiser'
  gem.homepage = 'http://github.com/chastell/signore'
  gem.author   = 'Piotr Szotkowski'
  gem.email    = 'chastell@chastell.net'

  gem.files            = `git ls-files -z`.split "\0"
  gem.extra_rdoc_files = ['README.md']
  gem.test_files       = Dir['spec/**/*.rb']

  gem.add_dependency 'trollop'
  gem.add_development_dependency 'diff-lcs'
  gem.add_development_dependency 'rspec'
end
