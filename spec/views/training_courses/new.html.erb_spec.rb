# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('training_courses/new', type: :view) do
  before do
    assign(:training_course, TrainingCourse.new)
  end

  it 'renders new training_course form' do
    render

    assert_select 'form[action=?][method=?]', training_courses_path, 'post' do
    end
  end
end
