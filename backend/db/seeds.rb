# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create(username: "test", password: "test", email: "test@gmail.com")
# Rails console
micropost = Micropost.create(date: "2024-05-02", distance: 10, time: 30, user_id: 1)
