$:.push File.expand_path("../lib", __FILE__)

require "rein/version"

Gem::Specification.new do |s|
  s.name        = "rein"
  s.version     = Rein::VERSION
  s.author      = "Josh Bassett"
  s.email       = "josh.bassett@gmail.com"
  s.homepage    = "http://github.com/nullobject/rein"
  s.summary     = "Database constraints made easy for ActiveRecord."
  s.description = "Rein adds bunch of methods to your ActiveRecord migrations so you can easily tame your database."

  s.rubyforge_project = "rein"

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map {|f| File.basename(f) }

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "simplecov"

  s.add_runtime_dependency "activerecord", '>= 3.2.0'
end
