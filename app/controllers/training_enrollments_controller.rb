class TrainingEnrollmentsController < ApplicationController

  def index
    @enrollments = TrainingEnrollment.all
  end

  def show
    @enrollment = TrainingEnrollment.find(params[:id])
  end

  def new
    @enrollment = TrainingEnrollment.new
  end

  def create
    @enrollment = TrainingEnrollment.new(enrollment_params)
    if @enrollment.save
      redirect_to training_enrollment_path(@enrollment)
    else
      #assign instance variables needed
      puts @enrollment.errors.full_messages
      render('new') #new action not being called, just renders new template in view
    end
  end

  def edit
    @enrollment = TrainingEnrollment.find_by(id: params[:id])

  end

  def update
    @enrollment =TrainingEnrollment.find_by(id: params[:id])
    if @enrollment.update(enrollment_params)
      redirect_to training_enrollment_path
    else
      render('edit')
    end
  end

  def delete
    @enrollment = TrainingEnrollment.find(params[:id])
  end

  def destroy
    @enrollment = TrainingEnrollment.find(params[:id])
    @enrollment.destroy
    #render('index')
    redirect_to training_enrollments_path
  end

  private

  def enrollment_params
    params.require(:training_enrollment).permit(:course_id, :user_id, :completion_status)
  end

end
