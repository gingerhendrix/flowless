# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.new(
  email: 'alex@flowless.net',
  first_name: 'Alex',
  last_name: 'Doe',
  roles: ['user', 'admin'],
  password: ENV['MSTPWD'],
  password_confirmation: ENV['MSTPWD']
)
admin.save!