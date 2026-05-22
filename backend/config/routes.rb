Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users, only: [:index, :destroy, :update, :show]
  post "/signup", to: "users#create"
  resources :microposts, only: [:create, :index, :destroy, :update]
  post '/login', to: 'auth#login'
  delete '/logout', to: 'auth#logout'
  get '/current_user', to: 'users#show'
  get '/check_email', to: 'users#check_email_availability'
  get '/user_posts', to: 'microposts#user_posts'
  get '/users/:id/info', to: 'users#get_user_info'
  post '/users/weekly_data', to: 'users#weekly_data'
  get '/current_user_role', to: 'users#role'
end
