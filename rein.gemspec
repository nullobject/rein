# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift(lib) unless $:.include?(lib)

require 'rein/version'

Gem::Specification.new do |s|
  s.name        = "rein"
  s.version     = Rein::VERSION
  s.author      = "Josh Bassett"
  s.email       = "josh.bassett@gmail.com"
  s.summary     = "Database constraints made easy for ActiveRecord."
  s.description = "Rein adds bunch of methods to your ActiveRecord migrations so you can easily tame your database."
  s.homepage    = "http://github.com/nullobject/rein"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "rein"

  s.add_bundler_dependencies

  s.files        = Dir.glob('lib/**/*') + %w(LICENSE README.md)
  s.require_path = 'lib'
end
