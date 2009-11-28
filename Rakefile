require 'spec/rake/spectask'

Spec::Rake::SpecTask.new :spec do |t|
  t.spec_opts = ['--options', 'spec/spec.opts']
end

namespace :spec do
  FileList['spec/**/*_spec.rb'].each do |file|
    spec = file.split('/').last[0...-8]
    desc "Run the #{spec} spec"
    Spec::Rake::SpecTask.new spec do |t|
      t.spec_files = [file]
      t.spec_opts  = ['--options', 'spec/spec.opts']
    end
  end
end

require 'jeweler'

Jeweler::Tasks.new do |gem|
  gem.authors  = ['Piotr Szotkowski']
  gem.email    = 'shot@hot.pl'
  gem.homepage = 'http://github.com/chastell/signore'
  gem.name     = 'signore'
  gem.summary  = 'signore: an email signature manager/randomiser'

  gem.add_dependency 'sequel'
  gem.add_dependency 'sqlite3-ruby'
  gem.add_dependency 'trollop'

  gem.add_development_dependency 'diff-lcs'
  gem.add_development_dependency 'jeweler'
  gem.add_development_dependency 'rspec'

end
