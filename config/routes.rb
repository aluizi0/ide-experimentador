Rails.application.routes.draw do
  resources :create_experiments
  get 'hello/world'
  get 'hello/worldGet', to: "hello#index"
  get 'experiment/create', to: "experiment#index"
  post 'experiment/create', to: "experiment#create"
  get 'experiment/classification', to: "classification#index"
  get 'experiment/get_all', to: "experiment#get_all"
  post 'tags/create', to: "tags#create"
  get 'tags/get_all', to: "tags#get_all"
  post 'experiment/add_tag', to: "experiment#add_tag"
  delete 'experiment/remove_tag', to: "experiment#remove_tag"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
