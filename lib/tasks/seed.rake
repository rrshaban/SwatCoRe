namespace :seed do
  desc "Generate a user account"
  task razi: :environment do
    @razi = User.new(name:    "Razi Shaban",
                    email:    "rshaban1@swarthmore.edu",
                    password: "password")
    @razi.skip_confirmation_notification!
    @razi.save!
    @razi.confirm!

  end

  desc "Generate lorem ipsum reviews for every class"
  task reviews: :environment do
    Course.all.each{ |course|
      3.times do
      content = Faker::Lorem.sentence(3)
      course.reviews.create!(content: content,
                                  department_id:  course.department_id,
                                  professor_id:   course.professor_id,
                                  user: User.find_by(id: 1),
                                  clarity: 3,
                                  intensity: 3,
                                  worthit: 3)
      end
    }
  end

end
