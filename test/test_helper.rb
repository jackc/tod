$LOAD_PATH.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'bundler/setup'
require 'active_support/time'
require 'tod'
require 'tod/core_extensions'
require 'tod/arel_extensions'
require 'minitest/autorun'
require 'pry'

Time.zone = "Central Time (US & Canada)"
