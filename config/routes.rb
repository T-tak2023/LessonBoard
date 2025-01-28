Rails.application.routes.draw do
  devise_for :instructors, controllers: {
    registrations: 'instructors/registrations'
  }, path_names: {
    edit: 'account/edit'
  }

  devise_for :students, skip: [:registrations]

  devise_scope :instructor do
    post 'instructors/guest_sign_in', to: 'instructors/sessions#guest_sign_in'
  end

  devise_scope :student do
    post 'students/guest_sign_in', to: 'students/sessions#guest_sign_in'

    get 'instructors/students/new', to: 'students/registrations#new', as: :new_student_registration
    post 'instructors/students', to: 'students/registrations#create', as: :student_registration
    get 'students/account/edit', to: 'students/registrations#edit', as: :edit_student_registration
    patch 'students/account', to: 'students/registrations#update', as: :update_student_registration
    put 'students/account', to: 'students/registrations#update'
  end

  get 'instructors/profile', to: 'instructors#profile', as: :instructor_profile
  get 'instructors/profile/edit', to: 'instructors#profile_edit', as: :instructor_profile_edit
  patch 'instructors/profile/edit', to: 'instructors#profile_update'

  get 'students/profile', to: 'students/profiles#profile', as: :student_profile
  get 'students/profile/edit', to: 'students/profiles#profile_edit', as: :student_profile_edit
  patch 'students/profile/edit', to: 'students/profiles#profile_update'

  namespace :instructors do
    resources :students, path: 'my-students', only: [:index, :show, :edit, :update, :destroy]
  end

  resources :lessons do
    collection do
      get 'student_index', to: 'lessons#student_index'
    end
  end

  namespace :instructors do
    resources :lesson_notes
  end

  namespace :students do
    resources :lesson_notes, only: [:index, :show, :edit, :update]
  end

  root "home#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
