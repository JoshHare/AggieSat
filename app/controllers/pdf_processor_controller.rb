# frozen_string_literal: true

# app/controllers/pdf_processor_controller.rb

class PdfProcessorController < ApplicationController
  def upload
    @user = User.find(current_user.id)
    @enrollments = []

    TrainingCourse.all.each do |course|
      result = TrainingService.check_enrollment_and_validity(course, @user) # Assuming check_enrollment_and_validity is defined elsewhere
      enrollment = {}
      enrollment[:course_title] = course.name
      enrollment[:course_id] = course.course_id
      training_enrollment = TrainingEnrollment.find_by(user_id: @user.id.to_i, course_id: course.course_id)
      if training_enrollment
        puts "DDDDD"
        enrollment[:date] = training_enrollment.completion_status.strftime('%d/%m/%Y')
      else
        enrollment[:date] = "N/A"
      end
      puts "#{course.course_id} #{enrollment[:date]}"
      enrollment[:result] = result
      @enrollments << enrollment


    end

    # Additionally, you may want to retrieve the actual TrainingEnrollments for display purposes
    # Uncomment the following line if you need TrainingEnrollments records for the user
    # @training_enrollments = TrainingEnrollment.where(user_id: @user)

    # Respond to HTML format request
    respond_to do |format|
      format.html # Render the view
    end
  end

  def process_pdf
    @processed_data = []
    if params[:pdf].present? && params[:pdf].respond_to?(:read)
      pdf_text = extract_text_from_pdf(params[:pdf].tempfile.path)
      @parsed = parse(pdf_text)
      @parsed.each do |course|
        user_id = current_user.id.to_i
        course_id = course[:course_id].to_i

        completion_date = Date.strptime(course[:completion_date], '%m/%d/%Y')
        d = TrainingCourse.exists?(course_id: course_id)
        puts d
        next unless TrainingCourse.exists?(course_id: course_id)

        # Try to find a record with the specified user_id and course_id
        puts "#{user_id} #{course_id}"
        @training_enrollment = TrainingEnrollment.find_or_initialize_by(user_id: user_id, course_id: course_id)
        # Update the completion_status attribute
        puts "#{@training_enrollment.new_record?}???"
        if @training_enrollment.new_record? || completion_date > @training_enrollment.completion_status
          # Update the completion_status attribute
          @training_enrollment.completion_status = completion_date
          @training_enrollment.save!
          @processed_data << { course_id: course_id, user_id: user_id, completion_date: completion_date }

        end
      end
      # Display a success flash notice
      flash[:success] = 'PDF successfully uploaded and processed!'
      # Output the extracted text to the terminal for testing
      render('processed')
    else
      flash[:error] = 'Please select a valid PDF file.'
      redirect_to(upload_path)
    end
  rescue StandardError => e
    flash[:error] = "An error occurred: #{e.message}"
    redirect_to(upload_path)
  end

  private

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
