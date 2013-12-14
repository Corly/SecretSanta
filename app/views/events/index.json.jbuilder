json.array!(@events) do |event|
  json.extract! event, :id, :start_date, :end_date, :status, :money_limit, :host_id, :has_started
  json.url event_url(event, format: :json)
end
