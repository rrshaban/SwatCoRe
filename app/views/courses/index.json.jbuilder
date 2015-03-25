json.array!(@courses) do |course|
  json.extract! course, :id, :Course, :name, :department, :crn
  json.url course_url(course, format: :json)
end
