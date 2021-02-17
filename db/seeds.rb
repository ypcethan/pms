# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless User.any?
  User.create(username: 'ethanchen', email: 'ethan@gmail.com', password: 'asdfasdf', admin: true)

  20.times do
    user = FactoryBot.create(:user)

    rand(20).times do
      FactoryBot.create(:project, user: user)
    end
  end
end
