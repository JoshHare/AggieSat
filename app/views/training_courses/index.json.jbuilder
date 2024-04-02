# frozen_string_literal: true

json.array!(@training_courses, partial: 'training_courses/training_course', as: :training_course)
