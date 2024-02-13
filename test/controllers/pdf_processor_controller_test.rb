# frozen_string_literal: true

require 'test_helper'

class PdfProcessorControllerTest < ActionDispatch::IntegrationTest
  test 'should get upload' do
    get pdf_processor_upload_url
    assert_response :success
  end
end
