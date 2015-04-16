require 'json'
file = File.read('classes.json')
hash = JSON.parse(file)

courseList = hash

i = 0
depts = Hash.new 
profs = Hash.new

puts courseList[0]
# courseList.each{ |course|
#   i += 1
# 	courseDept = course['dept']
# 	courseProf = course['profFirstName'] + ' ' + course['profLastName']

#   if !depts.include?(courseDept)
#   	depts[courseDept] = 1
#   else
#     depts[courseDept] += 1
#   end

#   if !profs.include?(courseProf)
#     # what if more courses are listed for a given prof?
#   	profs[courseProf] = 1
#   else
#     profs[courseProf] += 1
#   end
# }

# puts depts
# puts profs
# puts i

# departmentsArray.each{ |dept|
# 	Department.create!(name: dept)
# }

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
