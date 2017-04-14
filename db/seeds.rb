# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# require 'ffaker'

(1..5).each do |num|
  User.create(first_name: "first #{num} name",
  last_name: "last #{num} name", email: "example#{num}.com",
   password: '12345678', password_confirmation: '12345678')
 end

users = User.all
users.each do |user|
  (1..3).each do |num|
    Post.create(title: "Title #{num} for #{user.first_name}.",
    body: "Hello, my name is: #{user.first_name} #{user.last_name}", user: user)
  end
end
