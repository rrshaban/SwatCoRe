require 'json'
file = File.read('CourseScraped.json')
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
	dept = departments.find_by(name:prof[1]).deptartment_id
	Professor.create!( name: prof[0],
		  department_id: dept )
}

courseList.each{|course|
	courseName = course['courseName']
	courseDept = course['dept']
	courseId = course['courseId']
<<<<<<< HEAD
	courseProf = course['profFirstName'] + ' ' + course['profLastName']
        courseType = course['courseType']
	credit = course['credit']
	division = course['division']
	hasLab = course['hasLab']
	isFYS = course['isFYS']
	isWritingCourse = course['isWritingCourse']
	couseSummary = course['summary']
	#puts "#{courseName}\t#{courseDept}-#{courseId}"

	dept = departments.find_by(name: courseDept).deptartment_id
	prof = professors.find_by(name: courseProf).professor_id
=======
	# puts "#{courseName}\t#{courseDept}-#{courseId}"
>>>>>>> upstream/master

	Course.create!( name:        coursename,
               department_id:        dept,
                professor_id:        prof,
		       	 crn:        courseId ) 

<<<<<<< HEAD
=======
  # This might want to work, but we'll need to add all the depts and profs first
  Course.create!( name:        coursename,
              department:  courseDept,
              crn:         courseId)
  Course.save
>>>>>>> upstream/master
}
