json.array!(@stamps) do |stamp|
  json.extract! stamp, :id, :devkit, :damage, :giveaway
  json.url stamp_url(stamp, format: :json)
end
