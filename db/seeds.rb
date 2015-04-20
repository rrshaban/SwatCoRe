# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#


name  = " "
email = "parse@swarthmore.edu"
password = ENV['PARSE_PASSWORD']
password ||= "password"
@user = User.new(name:              name,
             email:                 email,
             password:              password)

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

    Course.create!( name:             course_name,
                department_id:        course_dept.id,
                professor_id:         course_prof.id,
                crn:                  course_crn )

    # puts course_name, course_prof, course_dept, course_crn
  }
}

Department.all.each{ |dept|

  # Changes the key to the full name - ugly, but it works
  case dept.name
    when "ANCH"
      dept.update(name: "Ancient History") 
    when "ANTH"
      dept.update(name: "Anthropology")
    when "ARAB" 
      dept.update(name: "Arabic")
    when "ARTH"
      dept.update(name: "Art History")
    when "ASTR"
      dept.update(name: "Astronomy")
    when "BIOL"
      dept.update(name: "Biology")
    when "BLST"
      dept.update(name: "Black Studies")
    when "CHEM"
      dept.update(name: "Chemistry")
    when "CHIN"
      dept.update(name: "Chinese")
    when "CLST"
      dept.update(name: "Classics")
    when "COGS"
      dept.update(name: "Cognitive Science")
    when "CPSC"
      dept.update(name: "Computer Science")
    when "DANC"
      dept.update(name: "Dance")
    when "ECON"
      dept.update(name: "Economics")
    when "EDUC"
      dept.update(name: "Educational Studies")
    when "ENGL"
      dept.update(name: "English Literature")
    when "ENGR"
      dept.update(name: "Engineering")
    when "ENVS"
      dept.update(name: "Environmental Studies")
    when "FMST"
      dept.update(name: "Film & Media Studies")
    when "FREN"
      dept.update(name: "French and Francophone Studies")
    when "GMST"
      dept.update(name: "German Studies")
    when "GREK"
      dept.update(name: "Greek")
    when "GSST"
      dept.update(name: "Gender & Sexuality Studies")
    when "HIST"
      dept.update(name: "History")
    when "INTP"
      dept.update(name: "Interpretation Theory")
    when "ISLM"
      dept.update(name: "Islamic Studies")
    when "JPNS"
      dept.update(name: "Japanese")
    when "LALS"
      dept.update(name: "Latin American and Latino Studies")
    when "LASC"
      dept.update(name: "Latin American Studies")
    when "LATN"
      dept.update(name: "Latin")
    when "LING"
      dept.update(name: "Linguistics")
    when "LITR"
      dept.update(name: "Comparative Literature")
    when "MATH"
      dept.update(name: "Math and Stats")
    when "MUSI"
      dept.update(name: "Music")
    when "OCST"
      dept.destroy  # off-campus study
    when "PEAC"
      dept.update(name: "Peace & Conflict Studies")
    when "PHED"
      dept.update(name: "Physical Education")
    when "PHIL"
      dept.update(name: "Philosophy")
    when "PHYS"
      dept.update(name: "Physics")
    when "POLS"
      dept.update(name: "Political Science")
    when "PPOL"
      dept.update(name: "Public Policy")
    when "PSYC"
      dept.update(name: "Psychology")
    when "RELG"
      dept.update(name: "Religion")
    when "RUSS"
      dept.update(name: "Russian")
    when "SOAN"
      dept.update(name: "Sociology & Anthropology")
    when "SOCI"
      dept.update(name: "Sociology")
    when "SPAN"
      dept.update(name: "Spanish")
    when "STAT"
      dept.update(name: "Statistics")
    when "STUA"
      dept.update(name: "Studio Art")
    when "THEA"
      dept.update(name: "Theater")
    else
      puts "Unnamed Department" # should never happen
  end
}

### DELETES BLANK PROFESSOR
Professor.find_by(name: " ").destroy


oldReviews = File.read(File.dirname(__FILE__) + '/Review.json') 
reviewList = JSON.parse(oldReviews)

reviewList['results'].each{ |review|
  	courseString = review['courseUniqueKey']
  	clarity = intensity = worthit = review['overallRating']

  	comment = review['comment'] 

    # turn courseString into useful information
  	courseCRN = (courseString.split('^')[0] + courseString.split('^')[1]).upcase
  	profFirst = (courseString.split('^')[2]).capitalize!
  	profLast = (courseString.split('^')[3]).capitalize!
  	profName = profLast + ", " + profFirst[0]
   	if !Course.find_by(crn: courseCRN)
  		next
  	end
  	dept_id = Course.find_by(crn: courseCRN).department_id
  	if !Professor.find_by(name: profName)
  		next
  	end
  	prof_id = Professor.find_by(name: profName).id
  	course_id = Course.find_by(crn: courseCRN).id
  	# puts courseString

  	Review.create( 
  	    content: comment,
  	    clarity: clarity,
  	    intensity: intensity,
  	    worthit: worthit,
  	    user_id: 1,
  	    course_id: course_id, 
  	    professor_id: prof_id,
  	    department_id: dept_id)
}


# Course.all.each{ |course|
#   3.times do
#   content = Faker::Lorem.sentence(3)
#   course.reviews.create!(content: content, 
#                               department_id:  course.department_id,
#                               professor_id:   course.professor_id,
#                               user: User.find_by(id: 1), 
#                               clarity: 3,
#                               intensity: 3,
#                               worthit: 3) 
#   end
# }
