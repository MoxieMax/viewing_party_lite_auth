Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'
  # resources :users, only: [:new, :create, :show]
  get '/login', to: 'users#login_form'
  # post '/login', to: 'users#login_user'

  get "/users/:id", to: "users#show"

  get "/users/:id/discover", to: "users/discover#index"
  
  get "/users/:id/movies", to: "users/movies#index"
  get "/users/:id/movies/:movie_id", to: "users/movies#show"

  get "/users/:user_id/movies/:movie_id/viewing_party/new", to: "users/viewing_parties#new"
end
