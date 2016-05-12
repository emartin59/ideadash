json.array!(@ideas) do |idea|
  json.extract! idea, :id, :title, :summary, :description, :user
  json.url idea_url(idea, format: :json)
end
