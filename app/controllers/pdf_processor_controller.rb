# app/controllers/pdf_processor_controller.rb

class PdfProcessorController < ApplicationController
  def upload
  end

  def process_pdf
    if params[:pdf].present? && params[:pdf].respond_to?(:read)
      pdf_text = extract_text_from_pdf(params[:pdf].tempfile.path)
      # Display a success flash notice
      flash[:success] = 'PDF successfully uploaded and processed!'
      # Output the extracted text to the terminal
      puts "Extracted Text from PDF:\n\n#{pdf_text}"
      render plain: pdf_text
    else
      flash[:error] = 'Please select a valid PDF file.'
      redirect_to upload_path
    end
  end

  private

  def extract_text_from_pdf(pdf_path)
    require 'pdf/reader'

    text = ''
    PDF::Reader.open(pdf_path) do |reader|
      reader.pages.each do |page|
        text << page.text.gsub(/\s+/, ' ').strip + "\n"
      end
    end

    text
  end
end
