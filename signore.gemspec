require 'English'
require 'pathname'

Gem::Specification.new do |gem|
  gem.author      = 'Piotr Szotkowski'
  gem.description = 'signore helps manage email signatures and select ' \
                    'random ones based on their tags'
  gem.email       = 'chastell@chastell.net'
  gem.homepage    = 'http://github.com/chastell/signore'
  gem.license     = 'AGPL-3.0-or-later'
  gem.name        = 'signore'
  gem.summary     = 'signore: an email signature manager/randomiser'
  gem.version     = '1.0.0'

  gem.required_ruby_version = '~> 3.2'

  gem.files       = `git ls-files -z`.split "\0"
  gem.executables = gem.files.grep(%r{^bin/}).map { |path| File.basename(path) }

  gem.add_dependency 'lovely_rufus', '~> 1.0'

  gem.add_development_dependency 'minitest',         '~> 5.6'
  gem.add_development_dependency 'minitest-focus',   '~> 1.1'
  gem.add_development_dependency 'rake',             '~> 13.0'
  gem.add_development_dependency 'reek',             '~> 6.0'
  gem.add_development_dependency 'rubocop',          '~> 1.0'
  gem.add_development_dependency 'rubocop-minitest', '~> 0.38.0'
  gem.add_development_dependency 'rubocop-rake',     '~> 0.7.0'

  gem.metadata['rubygems_mfa_required'] = 'true'
end
