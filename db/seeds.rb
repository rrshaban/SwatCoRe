# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(name:  "Studious Swattie",
             email: "example@swarthmore.edu",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "example#{n+1}@swarthmore.edu"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

Course.create!( name:        "Introduction to Computer Science",
                department:  "Computer Science",
                crn:         "CS021")

Course.create!( name:        "Introduction to Computer Systems",
                department:  "Computer Science",
                crn:         "CS031")

Course.create!( name:        "Data Structures and Algorithms",
                department:  "Computer Science",
                crn:         "CS035")


courses = Course.order(:created_at).take(3)
10.times do
  content = Faker::Lorem.sentence(5)
  courses.each { |course| course.reviews.create!(content: content, 
                                                    user: User.find_by(id: 1), 
                                                 overall: 5) }
end

