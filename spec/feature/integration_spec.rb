# location: spec/feature/integration_spec.rb
require 'rails_helper'

#RSpec.describe 'Creating a book with all valid fields: ', type: :feature do
 # scenario 'valid inputs' do
  #  visit new_book_path
   # fill_in 'book[title]', with: 'harry potter'
    #fill_in 'book[author]', with: 'jk rowling'
#    fill_in 'book[price]', with: 3.00
 #   select '2019', from: 'book[published_date(1i)]', visible: false
  #  select 'December', from: 'book[published_date(2i)]', visible: false
   # select '28', from: 'book[published_date(3i)]', visible: false 
    #select '04', from: 'book[published_date(4i)]', visible: false 
#    select '15', from: 'book[published_date(5i)]', visible: false
 #   click_on 'Create Book'
  #  visit books_path
   # expect(page).to have_content('harry potter')
  #end
#end

RSpec.describe 'Checking security/integrity of application with google oauth: ', type: :feature do

  before do
    Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
  end

  scenario 'authentication success' do #successfully log in with mockauth user
    visit new_user_session_path
    click_on 'Sign in with Google'

    visit test_path
    expect(page).to have_content('Welcome')
  end

  scenario 'authentication fail due to not being in scope of org' do #unsuccessful login due to email not in org scope
    OmniAuth.config.add_mock(:google_oauth2, {
      :info => {:email => 'bloblo@tamu.edu',
      :full_name => 'blob blob',
      :avatar_url => 'testing'},
    })
    visit new_user_session_path
    click_on 'Sign in with Google'

    expect(page).to have_content('email')
  end 

  #not a tamu email login does not work because mockauth does not hit google's endpoint

  scenario 'invalid login information' do #unsuccessful login due to login error
    OmniAuth.config.add_mock(:google_oauth2, {
      :info => {:email => 'amybob@tamu.edu',
      :full_name => '',
      :avatar_url => ''},
    })
    visit new_user_session_path
    click_on 'Sign in with Google'

    expect(page).to have_content('issues saving')
  end 
  
end

RSpec.describe 'Checking usability of website: ', type: :feature do

  before do
    Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
    OmniAuth.config.add_mock(:google_oauth2, {
      :info => {:email => 'amybob@tamu.edu',
      :full_name => 'amy bob',
      :avatar_url => 'testing'},
    })
  end

  scenario 'all paths accessible after log in as member' do #check usability as member
    visit new_user_session_path
    click_on 'Sign in with Google'

    visit test_path
    expect(page).to have_content('Welcome')
    visit upload_path
    expect(page).to have_content('Upload PDF')
    visit show_path
    expect(page).to have_content('Workday')
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
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
    OmniAuth.config.add_mock(:google_oauth2, {
      :info => {:email => 'amybob@tamu.edu',
      :full_name => '',
      :avatar_url => ''},
    })
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

  scenario 'upload expired training' do #expired trianing
    visit new_user_session_path
    click_on 'Sign in with Google'

    visit test_path
    expect(page).to have_content('Welcome')
    visit upload_path
    expect(page).to have_content('Upload PDF')
    visit show_path
    expect(page).to have_content('Workday')
  end

  scenario 'upload invalid file format' do #invalid file
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