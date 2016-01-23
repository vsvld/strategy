json.array!(@periods) do |period|
  json.extract! period, :id, :period_type, :date_from, :date_to
  json.url period_url(period, format: :json)
end
