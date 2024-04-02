# frozen_string_literal: true

json.extract!(training_course, :id, :created_at, :updated_at)
json.url(training_course_url(training_course, format: :json))
