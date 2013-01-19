# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

require 'loader'

Server.observers.disable :all do
  Loader.load_hubs
  Loader.detect_mirrors
  Loader.load_servers
end
