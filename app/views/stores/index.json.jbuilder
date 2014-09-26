json.array!(@stores) do |store|
  json.extract! store, :id, :name
  json.url store_url(store, format: :json)
end
