require 'json'
file = File.read('CourseScraped.json')
hash = JSON.parse(file)

courseList = hash['results']
courseList.each{|course|
	courseName = course['courseName']
	courseDept = course['dept']
	courseId = course['courseId']
	puts "#{courseName}\t#{courseDept}-#{courseId}"
}


Course.create!( name:        coursename,
                department:  courseDept,
                crn:         courseId)