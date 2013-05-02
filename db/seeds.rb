# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html
admins = {"Admin" => "admin@hemlock.demo"}
admin_password = "password"

puts 'Creating roles...'
YAML.load(ENV['ROLES']).each do |role|
  Role.find_or_create_by_name({ :name => role }, :without_protection => true)
  puts 'role: ' << role
end

puts 'Creating default users...'
admins.each do |name,email|
  puts "Creating #{name}=#{email}"
  user = User.create! :name => name, :email => email, :password => admin_password, :password_confirmation => admin_password
  user.add_role :admin
  puts 'Created User: ' << user.name
end
