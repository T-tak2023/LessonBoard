Rails.application.routes.draw do
  get 'students/index'
  devise_for :students, controllers: {
    registrations: 'students/registrations'
  }
  resources :students, only: [:index]
  devise_for :instructors

  get "instructors/profile" => "instructors#profile", as: :instructor_profile
  get "instructors/profile/edit" => "instructors#profile_edit", as: :instructor_profile_edit
  patch "instructors/profile/edit" => "instructors#profile_update"

  get "students/profile" => "students#profile", as: :student_profile
  get "students/profile/edit" => "students#profile_edit", as: :student_profile_edit
  patch "students/profile/edit" => "students#profile_update"

  resources :lessons
  resources :lesson_logs
  root "home#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
