# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('training_courses/index', type: :view) do
  before do
    assign(:training_courses, [
      TrainingCourse.create!,
      TrainingCourse.create!
    ]
    )
  end

  it 'renders a list of training_courses' do
    render
    Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
  end
end
