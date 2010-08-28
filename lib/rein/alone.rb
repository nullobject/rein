rc = "#{ENV['HOME']}/.rubyrc"
load(rc) if File.exist?(rc)

require 'rubygems'
require 'bundler'

envs = [:default]
envs << ENV["REIN_ENV"].downcase.to_sym if ENV["REIN_ENV"]
Bundler.setup(*envs)

path = File.join(File.expand_path(File.dirname(__FILE__)), '..')
$LOAD_PATH.unshift(path)

require 'rein'
