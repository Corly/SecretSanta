json.array!(@users) do |user|
  json.extract! user, :id, :email, :name, :auth_token, :uid
  json.url user_url(user, format: :json)
end
