# frozen_string_literal: true

class TrainingEnrollmentsController < ApplicationController
  def index
    @enrollments = TrainingEnrollment.all
    @valid_results = @enrollments.map { |enrollment| check_validity(enrollment) }
  end

  def show
    @enrollment = TrainingEnrollment.find(params[:id])
    @valid_result = check_validity(@enrollment)
  end

  def new
    @enrollment = TrainingEnrollment.new
  end

  def create
    @enrollment = TrainingEnrollment.new(enrollment_params)
    if @enrollment.save
      redirect_to(training_enrollment_path(@enrollment))
    else
      # assign instance variables needed
      Rails.logger.debug(@enrollment.errors.full_messages)
      render('new')
    end
  end

  def edit
    @enrollment = TrainingEnrollment.find_by(id: params[:id])
  end

  def update
    @enrollment = TrainingEnrollment.find_by(id: params[:id])
    if @enrollment.update(enrollment_params)
      redirect_to(training_enrollment_path)
    else
      render('edit')
    end
  end

  def delete
    @enrollment = TrainingEnrollment.find(params[:id])
  end

  def destroy
    @enrollment = TrainingEnrollment.find(params[:id])
    @enrollment.destroy!
    # render('index')
    redirect_to(training_enrollments_path)
  end

  private

  def check_validity(enrollment)
    if out_of_date?(enrollment)
      "BAD"
    elsif almost_out_of_date?(enrollment)
      "WARNING"
    else
      "GOOD"
    end
  end


  def enrollment_params
    params.require(:training_enrollment).permit(:course_id, :user_id, :completion_status)
  end

  def out_of_date?(enrollment) #checks if the training is expired (1 year old)
    if enrollment.completion_status.present?
      completion_status_threshold = 1.year.ago
      return enrollment.completion_status < completion_status_threshold
    end

    false
  end

  def almost_out_of_date?(enrollment)
    if enrollment.completion_status.present?
      completion_status_threshold = 11.months.ago
      return enrollment.completion_status < completion_status_threshold
    end

    false
  end

end
