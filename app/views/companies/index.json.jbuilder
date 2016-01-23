json.array!(@companies) do |company|
  json.extract! company, :id, :name, :code, :details
  json.url company_url(company, format: :json)
end
