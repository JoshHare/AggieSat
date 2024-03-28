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
RSpec.describe 'Navigating through the default member view like a user: ', type: :feature do

  before do
    Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
  end

  scenario 'authentication success' do #, :js => true, :driver => :rack_test do
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

