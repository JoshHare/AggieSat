# frozen_string_literal: true

# location: spec/feature/integration_spec.rb
# rubocop:disable RSpec/RepeatedExample
# rubocop:disable RSpec/RepeatedDescription
# rubocop:disable RSpec/MultipleDescribes
require 'rails_helper'

RSpec.describe('Checking security/integrity of application with google oauth: ', type: :feature) do
  before do
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
  end

  # successfully log in with mockauth user
  it 'authentication success' do
    OmniAuth.config.before_callback_phase do |env|
      env['omniauth.auth'] = OmniAuth.config.mock_auth[:default]
    end

    visit new_user_session_path
    click_on 'Sign in with Google'

    visit test_path
    expect(page).to(have_content('Welcome'))
  end

  # unsuccessful login due to email not in org scope
  it 'authentication fail due to not being in scope of org' do
    OmniAuth.config.before_callback_phase do |env|
      OmniAuth.config.mock_auth[:google_oauth2] = nil
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '2',
        info: {
          email: 'bloblo@tamu.edu',
          name: 'blob blob',
          image: 'testing'
        }
        # etc.
      }
                                                                        )
      env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
    end

    # puts Rails.application.env_config["omniauth.auth"]

    visit new_user_session_path
    click_on 'Sign in with Google'

    expect(page).to(have_content('email'))
  end

  # not a tamu email login does not work because mockauth does not hit google's endpoint

  # unsuccessful login due to login error
  it 'invalid login information' do
    OmniAuth.config.before_callback_phase do |env|
      OmniAuth.config.mock_auth[:google_oauth2] = nil
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '3',
        info: {
          email: 'amybob@tamu.edu',
          name: '',
          image: 'testing'
        }
        # etc.
      }
                                                                        )
      env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
    end

    visit new_user_session_path
    click_on 'Sign in with Google'

    expect(page).to(have_content('issues saving'))
  end
end

RSpec.describe('Checking usability of website: ', type: :feature) do
  before do
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
  end

  # check usability as member
  it 'all paths accessible after log in as member' do
    OmniAuth.config.before_callback_phase do |env|
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '28',
        info: {
          email: 'amybob@tamu.edu',
          name: 'amy bob',
          image: 'testing'
        }
        # etc.
      }
                                                                        )
      env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
    end

    visit new_user_session_path
    click_on 'Sign in with Google'

    visit test_path
    expect(page).to(have_content('Welcome'))
    visit upload_path
    expect(page).to(have_content('Upload PDF'))
    visit show_path
    expect(page).to(have_content('Workday'))
    # visit project_path  rn since its scoped to all we can skip
    # expect(page).to have_content('Create Project')

    click_on 'Logout?'
    expect(page).to(have_content('out successfully'))
  end

  # check usability as admin
  it 'all paths accessible after log in as member' do
    OmniAuth.config.before_callback_phase do |env|
      OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
        provider: 'google_oauth2',
        uid: '28',
        info: {
          email: 'amybob2@tamu.edu',
          name: 'amy bob 2',
          image: 'testing'
        }
        # etc.
      }
                                                                        )
      env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
    end
    visit new_user_session_path
    click_on 'Sign in with Google'

    visit test_path
    expect(page).to(have_content('Welcome'))
    visit upload_path
    expect(page).to(have_content('Upload PDF'))
    visit show_path
    expect(page).to(have_content('Workday'))
    visit projects_path
    expect(page).to(have_content('Create Project'))
    click_on '3'
    expect(page).to(have_content('AGS6'))

    click_on 'Logout?'
    expect(page).to(have_content('out successfully'))
  end
end

RSpec.describe('PDF proccessor integration test: ', type: :feature) do
  before do
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
  end

  # check usability as member
  it 'upload valid document from traintraq' do
    visit new_user_session_path
    click_on 'Sign in with Google'

    visit upload_path
    attach_file 'pdf', 'spec/test_files/validTrainingTT.pdf'
    click_button 'Process PDF'
    expect(page).to(have_content('successfully uploaded'))
    expect(page).to(have_content('Kate E Woodard 2112861 8/29/2023'))
  end

  # check usability as member
  it 'upload valid document from as combined pdf' do
    visit new_user_session_path
    click_on 'Sign in with Google'

    visit upload_path
    attach_file 'pdf', 'spec/test_files/validTrainingC.pdf'
    click_button 'Process PDF'
    expect(page).to(have_content('successfully uploaded'))
    expect(page).to(have_content('Pan Zhou 2112861 9/1/2023'))
  end

  # expired trianing??
  it 'upload expired training' do
    visit new_user_session_path
    click_on 'Sign in with Google'

    visit upload_path
    # change this later
    attach_file 'pdf', 'spec/test_files/AGSL.webp'
    click_button 'Process PDF'
    expect(page).to(have_content('error'))
  end

  # invalid file
  it 'upload invalid file format' do
    visit new_user_session_path
    click_on 'Sign in with Google'

    visit upload_path
    attach_file 'pdf', 'spec/test_files/AGSL.webp'
    click_button 'Process PDF'
    expect(page).to(have_content('error'))
  end

  # scenario 'upload invalid pdf (unexpected format)' do #invalid pdf
  #   visit new_user_session_path
  #   click_on 'Sign in with Google'

  #   visit upload_path
  #   attach_file "pdf", "spec/test_files/invalidTraining.pdf"
  #   click_button "Process PDF"
  #   expect(page).to have_content('bob')
  # end
end
# rubocop:enable RSpec/RepeatedExample
# rubocop:enable RSpec/RepeatedDescription
# rubocop:enable RSpec/MultipleDescribes
