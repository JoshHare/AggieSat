Rails.application.routes.draw do
  root 'home#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  #get '/auth/:provider/callback' => 'users/sessions#omniauth'
  #get '/user' => "test#index", :as => :user_root

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' } #{sessions: 'sessions'} if override sessions is used
  devise_scope :user do
    get 'users/sign_in', to: 'users/sessions#new', as: :new_user_session
    post 'users/sign_out', to: 'users/sessions#delete', as: :destroy_user_session
  end

  get 'home', to: 'home#index'

  get '/upload', to: 'pdf_processor#upload', as: 'upload'
  post 'pdf_processor/process_pdf'
  #post 'pdf_processor/csv'
  get 'pdf_processor/csv', to: 'pdf_processor#csv', as: :pdf_processor_csv
  get 'pdf_processor/batch', to: 'pdf_processor#batch'
  post 'pdf_processor/process_batch', to: 'pdf_processor#process_batch'


  get '/show' , to: 'member_view#show' , as: 'show'

  resources :training_enrollments do
    member do
      get :delete
    end
    collection do
      post :email_all
    end
    collection do
      get :user_enrollments
    end


  end
  resources :users do
    member do
      get :delete
    end


  end

  get 'training_courses/csv', to: 'training_courses#csv', as: :training_course_csv
  resources :training_courses
  #get 'training_courses/csv', to: 'training_courses#csv', as: :training_courses_csv

  # Route for projects index page
  get '/projects', to: 'projects#index', as: 'projects_index'
  get '/projects/:project_id/edit', to: 'projects#edit', as: 'edit_project'
  patch '/projects/:project_id', to: 'projects#update'
  resources :projects, only: [:show, :new, :create], param: :project_id do
    member do
      get :delete
      get :add_member, to: 'projects#_add_member_form'
      post :create_member
      delete :remove_member
      get :remove_member_confirmation, to: 'projects#remove_member'
      post :create_record
      post :accept_member
      post :reject_member
      #post :export_workday_attendance
      #get :csv, to: 'project#csv', as: :project_csv
    end
  end
  get 'projects/:project_id/csv', to: 'projects#csv', as: :project_workday_csv
  delete 'projects/:project_id', to: 'projects#destroy', as: 'destroy_project'

  resources :scheduled_workdays, only: [:create]

  get '/manage_members', to: 'manage_members#index', as: 'manage_members'
  get '/manage_members/new', to: 'manage_members#new', as: 'new_manage_member'
  resources :manage_members, only: [:index, :new, :create, :destroy] do
    post :update_role
  end
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
