require 'json'

scraper_output = "db/classes.json"

file = File.read(scraper_output)
data = JSON.parse(file)

data.each {|d|
  # {
  #   "name": "Intensive Elementary Modern Standard Arabic",
  #   "FYS": false,
  #   "credit": "N/A",
  #   "lab": false,
  #   "writing": false,
  #   "dept": "ARAB",
  #   "prereqs": "N/A",
  #   "crn": "001",
  #   "NSEP": false,
  #   "description": "N/A"
  # },
  # p d
  # p d["dept"]+d["crn"]

  full_crn = d["dept"] + d["crn"]

  courses = Course.where(crn: full_crn)

  if courses.count == 0
    p full_crn
  end

  courses.each { |course|
    course.update_attribute("fys", d["FYS"])
    course.update_attribute("credit", d["credit"])
    course.update_attribute("lab", d["lab"])
    course.update_attribute("writing", d["writing"])
    # course.update_attribute("prereqs", d["prereqs"]) # this doesn't exist in the DB yet - 8/27/15
  }
}


# p "Hello"

# p Course.first