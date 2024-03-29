require 'rails_helper'

RSpec.describe "training_courses/show", type: :view do
  before(:each) do
    assign(:training_course, TrainingCourse.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
