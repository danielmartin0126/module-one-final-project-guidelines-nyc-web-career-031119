require 'bundler'
Bundler.require
require_relative "../lib/pokemon.rb"

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'

require lib/.
