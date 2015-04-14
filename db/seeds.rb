# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# User.create!(name:  "Studious Swattie",
#              email: "example@swarthmore.edu",
#              password:              "foobar",
#              password_confirmation: "foobar",
#              admin: true)
require 'json'
file = File.read(File.dirname(__FILE__) + '/CourseScraped.json')
hash = JSON.parse(file)

courseList = hash['results']

departmentsArray = Array.new 
professorsArray = Array.new
courseList.each{|course|
	courseDept = course['dept']
	courseProf = course['profFirstName'] + ' ' + course['profLastName']

if !departmentsArray.include?(courseDept)
	departmentsArray.push(courseDept)
end

if !professorsArray.include?(courseProf)
	newArray = [courseProf, courseDept]
	professorsArray.push(newArray)
end
}

departmentsArray.each{|dept|
	Department.create!(name: dept)
}
professorsArray.each{|prof|
	dept = Department.find_by(name:prof[1]).id
	Professor.create!( name: prof[0],
		  department_id: dept )
}

courseList.each{|course|
	courseName = course['courseName']
	courseDept = course['dept']
	courseId = course['courseId']
	courseProf = course['profFirstName'] + ' ' + course['profLastName']
        courseType = course['courseType']
	credit = course['credit']
	division = course['division']
	hasLab = course['hasLab']
	isFYS = course['isFYS']
	isWritingCourse = course['isWritingCourse']
	couseSummary = course['summary']
	#puts "#{courseName}\t#{courseDept}-#{courseId}"

	dept = Department.find_by(name: courseDept).id
	prof = Professor.find_by(name: courseProf).id

	Course.create!( name:        courseName,
               department_id:        dept,
                professor_id:        prof,
		       	 crn:        courseId ) 

}
Department.create!(name: "Computer Science")

Professor.create!(name: "Ameet Soni",
                  department_id: 1)

1.times do |n|
  name  = Faker::Name.name
  # email = "example#{n+1}@swarthmore.edu"
  email = "rshaban1@swarthmore.edu"
  password = "password"
  @user = User.new(name:              name,
               email:                 email,
               password:              password)

  # so we don't accidentally spam Swarthmore again
  @user.skip_confirmation_notification!
  @user.save!
end

Course.create!( name:        "Introduction to Computer Science",
                department_id:  1,
                professor_id:   1,
                crn:         "CS021")

Course.create!( name:        "Introduction to Computer Systems",
                department_id:  1,
                professor_id:   1,
                crn:         "CS031")

Course.create!( name:        "Data Structures and Algorithms",
                department_id:  1,
                professor_id:   1,
                crn:         "CS035")


courses = Course.order(:created_at).take(3)
10.times do
  content = Faker::Lorem.sentence(5)
  courses.each { |course| course.reviews.create!(content: content, 
                                                    department_id:  1,
                                                    professor_id:   1,
                                                    user: User.find_by(id: 1), 
                                                    clarity: 5,
                                                    intensity: 5,
                                                    worthit: 5) }
end

