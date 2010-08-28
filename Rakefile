require 'rubygems'
require 'bundler'

Bundler.setup

$: << 'lib'
require 'rein/alone'

require 'rake'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'

desc "Launch an IRB session with the environment loaded"
task :console do
  exec("irb -I lib -r rein/alone")
end

Spec::Rake::SpecTask.new

namespace :rcov do
  Spec::Rake::SpecTask.new do |t|
    t.rcov = true
    t.rcov_opts = %w(--exclude .rubyrc,gems\/*,spec\/*,.bundle\/* --aggregate coverage.data)
  end

  RCov::VerifyTask.new(:verify) do |t|
    # Allow the coverage to exceed the threshold.
    t.require_exact_threshold = false

    t.threshold = 100.0
  end
end

task :default => :spec
