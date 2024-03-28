Rails.application.routes.draw do
  root 'test#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  #get '/auth/:provider/callback' => 'users/sessions#omniauth'
  #get '/user' => "test#index", :as => :user_root

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' } #{sessions: 'sessions'} if override sessions is used
  devise_scope :user do
    get 'users/sign_in', to: 'users/sessions#new', as: :new_user_session
    post 'users/sign_out', to: 'users/sessions#delete', as: :destroy_user_session
  end

  get 'test', to: 'test#index'

  get '/upload', to: 'pdf_processor#upload', as: 'upload'
  post 'pdf_processor/process_pdf'

  get '/show' , to: 'member_view#show' , as: 'show'

  resources :training_enrollments do
    member do
      get :delete
    end
    collection do
      post :email_all
    end
  end

  # Route for projects index page
  get '/projects', to: 'projects#index', as: 'projects_index'
  resources :projects, only: [:show, :new, :create], param: :project_id do
    member do
      get :delete
      get :add_member, to: 'projects#_add_member_form'
      post :create_member
      delete :remove_member
      get :remove_member_confirmation, to: 'projects#remove_member'
    end
  end
  delete 'projects/:project_id', to: 'projects#destroy', as: 'destroy_project'

  resources :scheduled_workdays, only: [:create]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
