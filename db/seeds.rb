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
             password:              password)

# so we don't accidentally spam Swarthmore again
@user.skip_confirmation_notification!
@user.save!
@user.confirm!


require 'json'
file = File.read(File.dirname(__FILE__) + '/classes.json')
json_parse = JSON.parse(file)

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

  # Changes the key to the full name - ugly, but it works
  if courseDept == "ANCH"
 	 courseDept = "Ancient History" 
  elsif courseDept == "ANTH"
 	 courseDept = "Anthropology"
  elsif courseDept == "ARAB" 
 	 courseDept  = "Arabic"
  elsif courseDept == "ARTH"
 	 courseDept = "Art History"
  elsif courseDept == "ASTR"
 	 courseDept  = "Astronomy"
  elsif courseDept == "BIOL"
 	 courseDept  = "Biology"
  elsif courseDept == "BLST"
 	 courseDept  = "Black Studies"
  elsif courseDept == "CHEM"
 	 courseDept  = "Chemistry"
  elsif courseDept == "CHIN"
 	 courseDept  = "Chinese"
  elsif courseDept == "CLST"
 	 courseDept  = "Classics"
  elsif courseDept == "COGS"
 	 courseDept  = "Cognitive Science"
  elsif courseDept == "CPSC"
	 courseDept  = "Computer Science"
  elsif courseDept == "DANC"
  	 courseDept  = "Dance"
  elsif courseDept == "ECON"
  	 courseDept  = "Economics"
  elsif courseDept == "EDUC"
 	 courseDept  = "Educational Studies"
  elsif courseDept == "ENGL"
 	 courseDept  = "English Literature"
  elsif courseDept == "ENGR"
 	 courseDept  = "Engineering"
  elsif courseDept == "ENVS"
 	 courseDept  = "Environmental Studies"
  elsif courseDept == "FMST"
 	 courseDept  = "Film & Media Studies"
  elsif courseDept == "FREN"
 	 courseDept  = "French and Francophone Studies"
  elsif courseDept == "GMST"
 	 courseDept  = "German Studies"
  elsif courseDept == "GREK"
 	 courseDept  = "Greek"
  elsif courseDept == "GSST"
 	 courseDept  = "Gender & Sexuality Studies"
  elsif courseDept == "HIST"
 	 courseDept  = "History"
  elsif courseDept == "ISLM"
 	 courseDept  = "Islamic Studies"
  elsif courseDept == "JPNS"
 	 courseDept  = "Japanese"
  elsif courseDept == "LALS"
 	 courseDept  = "Latin American Studies"
  elsif courseDept == "LATN"
 	 courseDept  = "Latin"
  elsif courseDept == "LING"
 	 courseDept  = "Linguistics"
  elsif courseDept == "LITR"
 	 courseDept  = "Comparative Literature"
  elsif courseDept == "MATH"
 	 courseDept  = "Math and Stats"
  elsif courseDept == "MUSI"
 	 courseDept  = "Music"
  elsif courseDept == "PEAC"
 	 courseDept  = "Peace & Conflict Studies"
  elsif courseDept == "PHED"
 	 courseDept  = "Physical Education"
  elsif courseDept == "PHIL"
 	 courseDept  = "Philosophy"
  elsif courseDept == "PHYS"
 	 courseDept  = "Physics"
  elsif courseDept == "POLS"
 	 courseDept  = "Political Science"
  elsif courseDept == "PSYC"
 	 courseDept  = "Psychology"
  elsif courseDept == "RELG"
 	 courseDept = "Religion"
  elsif courseDept == "RUSS"
 	 courseDept  = "Russian"
  elsif courseDept == "SOAN"
 	 courseDept  = "Sociology & Anthropology"
  elsif courseDept == "SOCI"
 	 courseDept  = "Sociology"
  elsif courseDept == "SPAN"
 	 courseDept  = "Spanish"
  elsif courseDept == "STAT"
 	 courseDept  = "Statistics"
  elsif courseDept == "STUA"
 	 courseDept = "Studio Art"
  elsif courseDept == "THEA"
 	 courseDept = "Theater"
  else
 	 puts "Unnamed Department"
  end


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

#puts depts
#puts profs
#puts i

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

