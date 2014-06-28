require 'rubygems'
require 'bundler/setup'


Dir.glob("spec/steps/**/*steps.rb") { |f| load f, true }
