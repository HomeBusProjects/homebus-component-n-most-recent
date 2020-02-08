#!/usr/bin/env ruby

require './options'
require './app'

n_most_recent_app_options = NMostRecentHomeBusAppOptions.new

n_most_recent = NMostRecentHomeBusApp.new n_most_recent_app_options.options
n_most_recent.run!
