Rails.application.routes.draw do
  devise_for :students
  devise_for :instructors

  get "instructors/profile" => "instructors#profile", as: :instructor_profile
  get "instructors/profile/edit" => "instructors#profile_edit", as: :instructor_profile_edit
  patch "instructors/profile/edit" => "instructors#profile_update"

  root "home#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
