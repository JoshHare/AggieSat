# location: spec/feature/integration_spec.rb
require 'rails_helper'

RSpec.describe 'Checking security/integrity of application with google oauth: ', type: :feature do

  before do
    Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
  end

  scenario 'authentication success' do #successfully log in with mockauth user
    OmniAuth.config.before_callback_phase do |env|
      env["omniauth.auth"] = OmniAuth.config.mock_auth[:default]
    end

    visit new_user_session_path
    click_on 'Sign in with Google'

    visit test_path
    expect(page).to have_content('Welcome')
  end

  scenario 'authentication fail due to not being in scope of org' do #unsuccessful login due to email not in org scope
    OmniAuth.config.before_callback_phase do |env|
      OmniAuth.config.mock_auth[:google_oauth2] = nil
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        :provider => 'google_oauth2',
        :uid => '2',
        :info => {:email => 'bloblo@tamu.edu',
        :name => 'blob blob',
        :image => 'testing'},
        #etc.
      })
      env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
    end
    
    #puts Rails.application.env_config["omniauth.auth"]
    
    visit new_user_session_path
    click_on 'Sign in with Google'

    expect(page).to have_content('email')
  end 

  #not a tamu email login does not work because mockauth does not hit google's endpoint

  scenario 'invalid login information' do #unsuccessful login due to login error
    OmniAuth.config.before_callback_phase do |env|
      OmniAuth.config.mock_auth[:google_oauth2] = nil
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        :provider => 'google_oauth2',
        :uid => '3',
        :info => {:email => 'amybob@tamu.edu',
        :name => '',
        :image => 'testing'},
        #etc.
      })
      env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
    end

    visit new_user_session_path
    click_on 'Sign in with Google'

    expect(page).to have_content('issues saving')
  end 
  
end

RSpec.describe 'Checking usability of website: ', type: :feature do

  before do
    Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
  end

  scenario 'all paths accessible after log in as member' do #check usability as member
    OmniAuth.config.before_callback_phase do |env|
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        :provider => 'google_oauth2',
        :uid => '28',
        :info => {:email => 'amybob@tamu.edu',
        :name => 'amy bob',
        :image => 'testing'},
      #etc.
      })
      env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
    end

    visit new_user_session_path
    click_on 'Sign in with Google'

    visit test_path
    expect(page).to have_content('Welcome')
    visit upload_path
    expect(page).to have_content('Upload PDF')
    visit show_path
    expect(page).to have_content('Workday')

    click_on 'Logout?'
    expect(page).to have_content('out successfully')
  end

  scenario 'all paths accessible after log in as member' do #check usability as project lead
    visit new_user_session_path
    click_on 'Sign in with Google'

    visit test_path
    expect(page).to have_content('Welcome')
    visit upload_path
    expect(page).to have_content('Upload PDF')
    visit show_path
    expect(page).to have_content('Workday')
  end

end

RSpec.describe 'PDF proccessor integration test: ', type: :feature do

  before do
    Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
  end

  scenario 'upload valid document from traintraq' do #check usability as member
    visit new_user_session_path
    click_on 'Sign in with Google'

    visit upload_path
    attach_file "pdf", "spec/test_files/validTrainingTT.pdf"
    click_button "Process PDF"
    expect(page).to have_content('successfully uploaded')
    expect(page).to have_content('Kate E Woodard 2112861 8/29/2023')

  end

  scenario 'upload valid document from as combined pdf' do #check usability as member
    visit new_user_session_path
    click_on 'Sign in with Google'

    visit upload_path
    attach_file "pdf", "spec/test_files/validTrainingC.pdf"
    click_button "Process PDF"
    expect(page).to have_content('successfully uploaded')
    expect(page).to have_content('Pan Zhou 2112861 9/1/2023')

  end

  scenario 'upload expired training' do #expired trianing??
    visit new_user_session_path
    click_on 'Sign in with Google'

    visit upload_path
    attach_file "pdf", "spec/test_files/AGSL.webp" #change this later
    click_button "Process PDF"
    expect(page).to have_content('error')
  end

  scenario 'upload invalid file format' do #invalid file
    visit new_user_session_path
    click_on 'Sign in with Google'

    visit upload_path
    attach_file "pdf", "spec/test_files/AGSL.webp"
    click_button "Process PDF"
    expect(page).to have_content('error')
  end 

 #scenario 'upload invalid pdf (unexpected format)' do #invalid pdf
 #   visit new_user_session_path
 #   click_on 'Sign in with Google'

 #   visit upload_path
 #   attach_file "pdf", "spec/test_files/invalidTraining.pdf" 
 #   click_button "Process PDF"
 #   expect(page).to have_content('bob')
 # end 
  
end