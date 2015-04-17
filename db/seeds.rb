# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#


name  = "Razi Shaban"
email = "rshaban1@swarthmore.edu"
password = "password"
@user = User.new(name:              name,
             email:                 email,
             password:              password,
             admin:                 true)

# so we don't accidentally spam Swarthmore again
@user.skip_confirmation_notification!
@user.save!
@user.confirm!


require 'json'
fall14 = File.read(File.dirname(__FILE__) + '/fall2014.json')
spring15 = File.read(File.dirname(__FILE__) + '/spring2015.json')
fall15 = File.read(File.dirname(__FILE__) + '/fall2015.json')
json_parse = JSON.parse(fall14) + JSON.parse(spring15) + JSON.parse(fall15)

courseList = json_parse
depts = Hash.new 
profs = Hash.new
courses = Hash.new


# { # EXAMPLE JSON INPUT FROM AJ'S scraper.py
#     "Course Name": "FYS: Augustus and Rome",
#     "Days and Times": "TTH 02:40pm-03:55pm",
#     "Instructor": "Turpin, W",
#     "Location": "Kohlberg 334",
#     "Misc": " ",
#     "Registration-ID": "ANCH 016 01"
# }
###### COURSE MODEL 
#     t.string   "name"
#     t.string   "crn"
#     t.datetime "created_at",    null: false
#     t.datetime "updated_at",    null: false
#     t.integer  "professor_id"
#     t.integer  "department_id"

# builds list of unique entries
courseList.each{ |course|
  courseDept = course['Registration-ID'].split[0]
  courseProf = course['Instructor']

  
  if !depts.include?(courseDept)
    depts[courseDept] = 1
  else
    depts[courseDept] += 1
  end

  if !profs.include?(courseProf)
    # what if more courses are listed for a given prof?
    #
    #
    #
    # => PROBLEM
    #
    #
    profs[courseProf] = { courseDept => 1 }
  else
    if !profs[courseProf].include?(courseDept)
      profs[courseProf][courseDept] = 1
    else
      profs[courseProf][courseDept] += 1
    end
  end

}

depts.keys.each{ |dept|
  Department.create!(name: dept)
}

profs.keys.each{ |prof|
  dept_id = Department.find_by(name: profs[prof].keys[0]).id
  Professor.create!( 
    name: prof,
    department_id: dept_id)
}


courseList.each{ |course|
  course_name = course['Course Name']
  course_prof = Professor.find_by(name: course['Instructor'])
  course_dept = Department.find_by(name: course['Registration-ID'].split[0])
  course_crn  = course['Registration-ID'].split[0..1].join

  
  if !courses.include?(course_crn)
    courses[course_crn] = { 'course_prof' => { course_prof => 1},
                            'course_name' => course_name,
                            'course_dept' => course_dept }
  else
    if !courses[course_crn]['course_prof'].include?(course_prof)
      courses[course_crn]['course_prof'][course_prof] = 1
    else
      courses[course_crn]['course_prof'][course_prof] += 1
      # ugh why did I do this
    end
  end
}


courses.keys.each{ |course_crn|
  course_name = courses[course_crn]['course_name']
  course_dept = courses[course_crn]['course_dept']

  courses[course_crn]['course_prof'].keys.each { |course_prof|

    Course.create!( name:                 course_name,
                department_id:        course_dept.id,
                professor_id:         course_prof.id,
                crn:                  course_crn )

    # puts course_name, course_prof, course_dept, course_crn
  }
}

### DELETES BLANK PROFESSOR
Professor.find_by(name: " ").destroy


# Course.all.each{ |course|
#   3.times do
#   content = Faker::Lorem.sentence(5)
#   course.each { |course| course.reviews.create!(content: content, 
#                                                     department_id:  1,
#                                                     professor_id:   1,
#                                                     user: User.find_by(id: 1), 
#                                                     clarity: 3,
#                                                     intensity: 3,
#                                                     worthit: 3) }
# end
# }

