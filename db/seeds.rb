# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
require 'updater'

tlds = YAML.load_file(File.expand_path('../seeds/tld_to_country_name.yml', __FILE__))

Updater.load_hubs!.each_pair do |key, value|
  begin
    Hub.find_or_create_by_name!(:name => tlds[key][:country], :host => value, :code => key)
    print "\n => #{tlds[key][:country]} hub loaded"
  rescue Exception => msg
    puts msg
    puts key, value
  end
end

puts
