# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = User.create(email: 'admin@applaw.mobi', password: '123456', password_confirmation: '123456')
puts "Created user: #{user.email}"
mole = Mole.create(access_token: '2.00QjeSEDVLZ5aD96fb13bb8604sg3a', name: 'Stanley_Deng_8', weibo_id: '2811950310', is_expired: false)
puts "Created mole: #{mole.name}"
