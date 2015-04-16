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

# 1.times do |n|
#   name  = "Razi Shaban"
#   email = "rshaban1@swarthmore.edu"
#   password = "password"
#   @user = User.new(name:              name,
#                email:                 email,
#                password:              password)

#   # so we don't accidentally spam Swarthmore again
#   @user.skip_confirmation_notification!
#   @user.save!
#   @user.confirm!
# end

require 'json'
file = File.read(File.dirname(__FILE__) + '/classes.json')
hash = JSON.parse(file)

courseList = hash

i = 0
depts = Hash.new 
profs = Hash.new

# puts courseList
courseList.each{ |course|
  i += 1
  courseDept = course['Registration-ID'].split[0]
  courseProf = course['Instructor']

  if !depts.include?(courseDept)
    depts[courseDept] = 1
  else
    depts[courseDept] += 1
  end

  if !profs.include?(courseProf)
    # what if more courses are listed for a given prof?
    profs[courseProf] = { courseDept => 1 }
  else
    if !profs[courseProf].include?(courseDept)
      profs[courseProf][courseDept] = 1
    else
      profs[courseProf][courseDept] += 1
    end
  end
}

puts depts
puts profs
puts i

# depts.keys.each{ |dept|
#   Department.create!(name: dept)
# }

profs.keys.each{ |prof|
  dept_id = Department.find_by(name: profs[prof].keys[0]).id
  Professor.create!( 
    name: prof,
    department_id: dept_id)
}

# courseList.each{ |course|
#   courseName = course['courseName']
#   courseDept = course['dept']
#   courseId = course['courseId']

#   courseProf = course['profFirstName'] + ' ' + course['profLastName']
#   courseType = course['courseType']
#   credit = course['credit']
#   division = course['division']
#   hasLab = course['hasLab']
#   isFYS = course['isFYS']
#   isWritingCourse = course['isWritingCourse']
#   couseSummary = course['summary']
#   #puts "#{courseName}\t#{courseDept}-#{courseId}"

#   dept = departments.find_by(name: courseDept).department_id
#   prof = professors.find_by(name: courseProf).professor_id

#   Course.create!( name:        coursename,
#                department_id:        dept,
#                 professor_id:        prof,
#              crn:        courseId ) 


# }












# hash = JSON.parse(file)

# courseList = hash['results']

# departmentsArray = Array.new 
# professorsArray = Array.new
# courseList.each{|course|
# 	courseDept = course['dept']
# 	courseProf = course['profFirstName'] + ' ' + course['profLastName']

# if !departmentsArray.include?(courseDept)
# 	departmentsArray.push(courseDept)
# end

# if !professorsArray.include?(courseProf)
# 	newArray = [courseProf, courseDept]
# 	professorsArray.push(newArray)
# end
# }

# departmentsArray.each{|dept|
# 	Department.create!(name: dept)
# }
# professorsArray.each{|prof|
# 	dept = Department.find_by(name:prof[1]).id
# 	Professor.create!( name: prof[0],
# 		  department_id: dept )
# }

# courseList.each{|course|
# 	courseName = course['courseName']
# 	courseDept = course['dept']
# 	courseId = course['courseId']
# 	courseProf = course['profFirstName'] + ' ' + course['profLastName']
#         courseType = course['courseType']
# 	credit = course['credit']
# 	division = course['division']
# 	hasLab = course['hasLab']
# 	isFYS = course['isFYS']
# 	isWritingCourse = course['isWritingCourse']
# 	couseSummary = course['summary']
# 	#puts "#{courseName}\t#{courseDept}-#{courseId}"

# 	dept = Department.find_by(name: courseDept).id
# 	prof = Professor.find_by(name: courseProf).id

# 	Course.create!( name:        courseName,
#                department_id:        dept,
#                 professor_id:        prof,
# 		       	 crn:        courseId ) 

# }
# Department.create!(name: "Computer Science")

# Professor.create!(name: "Ameet Soni",
#                   department_id: 1)



# Course.create!( name:        "Introduction to Computer Science",
#                 department_id:  1,
#                 professor_id:   1,
#                 crn:         "CS021")

# Course.create!( name:        "Introduction to Computer Systems",
#                 department_id:  1,
#                 professor_id:   1,
#                 crn:         "CS031")

# Course.create!( name:        "Data Structures and Algorithms",
#                 department_id:  1,
#                 professor_id:   1,
#                 crn:         "CS035")


# courses = Course.order(:created_at).take(3)
# 10.times do
#   content = Faker::Lorem.sentence(5)
#   courses.each { |course| course.reviews.create!(content: content, 
#                                                     department_id:  1,
#                                                     professor_id:   1,
#                                                     user: User.find_by(id: 1), 
#                                                     clarity: 5,
#                                                     intensity: 5,
#                                                     worthit: 5) }
# end

