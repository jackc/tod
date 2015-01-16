$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'bundler/setup'
require 'tod'
require 'tod/core_extensions'
require 'minitest/autorun'
