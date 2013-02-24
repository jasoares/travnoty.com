# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Admin.create! do |admin|
  admin.email                 = ENV['ADMIN_EMAIL'].dup
  admin.password              = ENV['ADMIN_PASSWORD'].dup
  admin.password_confirmation = ENV['ADMIN_PASSWORD'].dup
end unless Admin.where(:email => ENV['ADMIN_EMAIL']).exists?
