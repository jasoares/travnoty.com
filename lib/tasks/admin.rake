namespace :admin do
  desc 'Create the application admin from .env'
  task :create => :environment do
    Admin.create! do |admin|
      admin.email                 = ENV['ADMIN_EMAIL'].dup
      admin.password              = ENV['ADMIN_PASSWORD'].dup
      admin.password_confirmation = ENV['ADMIN_PASSWORD'].dup
    end unless Admin.where(:email => ENV['ADMIN_EMAIL']).exists?
  end
end
