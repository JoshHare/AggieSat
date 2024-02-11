# frozen_string_literal: true

# app/controllers/pdf_processor_controller.rb

class PdfProcessorController < ApplicationController
  def upload; end

  def process_pdf
    if params[:pdf].present? && params[:pdf].respond_to?(:read)
      pdf_text = extract_text_from_pdf(params[:pdf].tempfile.path)
      @parsed = parse(pdf_text)
      # Display a success flash notice
      flash[:success] = 'PDF successfully uploaded and processed!'
      # Output the extracted text to the terminal for testing
      Rails.logger.debug { "Extracted Text from PDF:\n\n#{@parsed}" }
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
        text << "#{page.text.gsub(/\s+/, ' ').strip}\n"
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
