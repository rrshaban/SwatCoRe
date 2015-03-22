json.array!(@courses) do |course|
  json.extract! course, :id, :name, :department, :professor
  json.url course_url(course, format: :json)
end
