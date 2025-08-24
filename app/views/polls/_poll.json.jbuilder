json.extract! poll, :id, :question, :status, :poll_type, :user_id, :expires_at, :max_choices, :created_at, :updated_at
json.url poll_url(poll, format: :json)
