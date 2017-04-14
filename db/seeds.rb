# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'ffaker'

5.times { User.create(first_name: FFaker::Name.first_name,
  last_name: FFaker::Name.last_name, email: FFaker::Internet.email,
   password: '12345678', password_confirmation: '12345678') }

users = User.all
users.each do |user|
  3.times { Post.create(title: FFaker::Lorem.word, body: FFaker::HipsterIpsum.paragraph, user: user) }
end
