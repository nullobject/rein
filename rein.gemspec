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

  s.files        = Dir.glob('lib/**/*') + %w(LICENSE README.md)
  s.require_path = 'lib'
  
  s.add_dependency 'activerecord'

  s.add_development_dependency 'bundler', '~> 1.0.0'
  s.add_development_dependency 'hirb',    '~> 0.3.2'
  s.add_development_dependency 'rake',    '~> 0.8.7'
  s.add_development_dependency 'rcov',    '~> 0.9.8'
  s.add_development_dependency 'rspec',   '~> 1.3.0'
  s.add_development_dependency 'rr',      '~> 1.0.0'
  s.add_development_dependency 'wirble',  '~> 0.1.3'
  
end
