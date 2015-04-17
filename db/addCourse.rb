require 'json'
file = File.read('classes.json')
hash = JSON.parse(file)

courseList = hash

i = 0
j = 0
depts = Hash.new 
profs = Hash.new

# puts courseList
courseList.each{ |course|
  i += 1
  courseDept = course['Registration-ID'].split[0]
  
  # This is ugly, but hopefully it works
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
        j += 1
  else
    depts[courseDept] += 1
  end  

  courseDept = course['Registration-ID'].split[0]
  courseProf = course['Instructor']
  
  if !profs.include?(courseProf)
    # what if more courses are listed for a given prof?
  	profs[courseProf] = 1
  else
    profs[courseProf] += 1
  end
}

puts depts
puts profs
puts i
puts j


#depts.each{ |dept|
#	Department.create!(name: dept)
#}

# professorsArray.each{ |prof|
# 	dept = departments.find_by(name:prof[1]).department_id
# 	Professor.create!( name: prof[0],
# 		  department_id: dept )
# }

# courseList.each{ |course|
# 	courseName = course['courseName']
# 	courseDept = course['dept']
# 	courseId = course['courseId']

# 	courseProf = course['profFirstName'] + ' ' + course['profLastName']
#   courseType = course['courseType']
# 	credit = course['credit']
# 	division = course['division']
# 	hasLab = course['hasLab']
# 	isFYS = course['isFYS']
# 	isWritingCourse = course['isWritingCourse']
# 	couseSummary = course['summary']
# 	#puts "#{courseName}\t#{courseDept}-#{courseId}"

# 	dept = departments.find_by(name: courseDept).department_id
# 	prof = professors.find_by(name: courseProf).professor_id

# 	Course.create!( name:        coursename,
#                department_id:        dept,
#                 professor_id:        prof,
# 		       	 crn:        courseId ) 


# }
