Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
get '/new' => 'games#new', as: :new
post '/score' => 'games#score', as: :score
get 'clean' => 'games#clean'
get '/' => 'games#new'

end
