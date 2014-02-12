json.array!(@feedbacks) do |feedback|
  json.extract! feedback, :question, :answer, :public
  json.url feedback_url(feedback, format: :json)
end
