Rails.application.routes.draw do
  devise_for :instructors, path_names: {
    edit: 'account/edit'
  }

  devise_for :students, controllers: {
    registrations: 'students/registrations'
  }, path_names: {
    edit: 'account/edit'
  }

  devise_scope :instructor do
    post 'instructors/guest_sign_in', to: 'instructors/sessions#guest_sign_in'
  end

  devise_scope :student do
    post 'students/guest_sign_in', to: 'students/sessions#guest_sign_in'
  end

  namespace :instructors do
    resources :students, path: 'my-students', only: [:index, :show, :edit, :update, :destroy]
  end

  namespace :students do
    get 'profile', to: 'profiles#profile', as: :profile
    get 'profile/edit', to: 'profiles#profile_edit', as: :profile_edit
    patch 'profile/edit', to: 'profiles#profile_update'
  end

  get "instructors/profile" => "instructors#profile", as: :instructor_profile
  get "instructors/profile/edit" => "instructors#profile_edit", as: :instructor_profile_edit
  patch "instructors/profile/edit" => "instructors#profile_update"

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
