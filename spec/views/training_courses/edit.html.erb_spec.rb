# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('training_courses/edit', type: :view) do
  let(:training_course) do
    TrainingCourse.create!
  end

  before do
    assign(:training_course, training_course)
  end

  it 'renders the edit training_course form' do
    render

    assert_select 'form[action=?][method=?]', training_course_path(training_course), 'post' do
    end
  end
end
