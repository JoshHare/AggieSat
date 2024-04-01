# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('training_courses/show', type: :view) do
  before do
    assign(:training_course, TrainingCourse.create!)
  end

  it 'renders attributes in <p>' do
    render
  end
end
