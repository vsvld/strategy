json.array!(@periods_groups) do |periods_group|
  json.extract! periods_group, :id
  json.url periods_group_url(periods_group, format: :json)
end
