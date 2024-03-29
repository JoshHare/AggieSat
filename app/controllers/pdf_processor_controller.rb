# frozen_string_literal: true

# app/controllers/pdf_processor_controller.rb

class PdfProcessorController < ApplicationController
  def upload
    @user = User.find(current_user.id)
    @enrollments = []

    TrainingCourse.all.find_each do |course|
      result = TrainingService.check_enrollment_and_validity(course, @user)
      enrollment = {}
      enrollment[:course_title] = course.name
      enrollment[:course_id] = course.course_id
      training_enrollment = TrainingEnrollment.find_by(user_id: @user.id, course_id: course.course_id)
      if training_enrollment
        Rails.logger.debug('DDDDD')
        enrollment[:date] = training_enrollment.completion_status.strftime('%m/%d/%Y')
      else
        enrollment[:date] = 'N/A'
      end
      Rails.logger.debug { "#{course.course_id} #{enrollment[:date]}" }
      enrollment[:result] = result
      @enrollments << enrollment
    end

    # Respond to HTML format request
    respond_to do |format|
      format.html
    end
  end

  def process_pdf
    if pdf_params_valid?
      process_valid_pdf
    else
      handle_invalid_pdf
    end
  rescue StandardError => e
    flash[:error] = "An error occurred: #{e.message}"
    Rails.logger.error("An error occurred: #{e.message}")
    #   redirect_to(upload_path)
  end

  private

  def pdf_params_valid?
    params[:pdf].present? && params[:pdf].respond_to?(:read)
  end

  def process_valid_pdf
    @processed_data = []
    pdf_text = extract_text_from_pdf(params[:pdf].tempfile.path)
    parsed_courses = parse(pdf_text)

    parsed_courses.each do |course|
      process_course(course)
    end

    flash[:success] = 'PDF successfully uploaded and processed!'
    render('processed')
  end

  def handle_invalid_pdf
    flash[:error] = 'Please select a valid PDF file.'
    redirect_to(upload_path)
  end

  def process_course(course)
    user_id = Integer(current_user.id)
    course_id = Integer(course[:course_id])
    completion_date = Date.strptime(course[:completion_date], '%m/%d/%Y')

    if training_course_exists?(course_id)
      update_training_enrollment(user_id, course_id, completion_date)
      @processed_data << { course_id: course_id, user_id: user_id, completion_date: completion_date }
    end
  end

  def training_course_exists?(course_id)
    TrainingCourse.exists?(course_id: course_id)
  end

  def update_training_enrollment(user_id, course_id, completion_date)
    training_enrollment = TrainingEnrollment.find_or_initialize_by(user_id: user_id, course_id: course_id)
    puts "JERE"
  puts @processed_data
  puts "New Record: #{training_enrollment.new_record?}"
  puts "Completion Date: #{completion_date}"
  puts "Completion Status: #{training_enrollment.completion_status}"
  puts "comp: #{completion_date.to_date > training_enrollment.completion_status.to_date}"
    puts @processed_data
    if training_enrollment.new_record? || completion_date.to_date < training_enrollment.completion_status.to_date
      training_enrollment.completion_status = completion_date
      training_enrollment.save!
      puts "SAVED"
    end
  end

  def extract_text_from_pdf(pdf_path)
    require('pdf/reader')

    text = ''
    PDF::Reader.open(pdf_path) do |reader|
      reader.pages.each do |page|
        text += "#{page.text.gsub(/\s+/, ' ').strip}\n"
      end
    end

    text
  end

  def parse(text)
    format = identify_format(text)
    results = []

    if format == 'Employee'
      pattern = %r{TrainTraq Transcript Name: (\w+\s\w+) .*? (\d+) : .*? Was successfully completed on (\d{1,2}/\d{1,2}/\d{4})}

      matches = text.scan(pattern)
      matches.each do |match|
        student_name = match[0]
        course_id = match[1]
        completion_date = match[2]
        results << { student_name: student_name, course_id: course_id, completion_date: completion_date }
      end
    elsif format == 'Student'
      name_match = text.match(/Name:\s+(.*?)\s+UIN:/)
      name = name_match ? name_match[1] : 'None'

      pattern = %r{(\d{7}) (\d{1,2}/\d{1,2}/\d{4})}m

      matches = text.scan(pattern)
      matches.each do |match|
        course_id = match[0]
        completion_date = match[1]
        results << { student_name: name, course_id: course_id, completion_date: completion_date }
      end
    else
      Rails.logger.debug('ERROR: COULD NOT IDENTIFY FORMAT')
    end

    results
  end

  def identify_format(text)
    if /TrainTraq Transcript Name:.*Email:.*Work Address:.*Employer:.*/.match?(text)
      'Employee'
    elsif /TrainTraq Transcript Name:.*UIN:.*Date:.*/.match?(text)
      Rails.logger.debug('Student')
      'Student'
    else
      'ERROR: COULD NOT IDENTIFY FORMAT'
    end
  end
end
