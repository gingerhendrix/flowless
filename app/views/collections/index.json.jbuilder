json.array!(@collections) do |collection|
  json.extract! collection, :name
  json.url collection_url(collection, format: :json)
end
