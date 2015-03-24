json.array!(@models) do |model|
  json.extract! model, :id, :Course, :name, :department, :crn
  json.url model_url(model, format: :json)
end
