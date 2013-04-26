$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'bundler/setup'
require 'tod'
require 'test/unit'
require 'shoulda'
require 'mocha/setup'
