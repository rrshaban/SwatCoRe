require 'json'
file = File.read('CourseScraped.json')
hash = JSON.parse(file)

courseList = hash['results']
courseList.each{|course|
	courseName = course['courseName']
	courseDept = course['dept']
	courseId = course['courseId']
	# puts "#{courseName}\t#{courseDept}-#{courseId}"


  # This might want to work, but we'll need to add all the depts and profs first
  Course.create!( name:        coursename,
              department:  courseDept,
              crn:         courseId)
  Course.save
}
