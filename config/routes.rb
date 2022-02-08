Rails.application.routes.draw do
  get '/tools/followers/:user', to: 'tools#followers'
  get '/tools/user/:user', to: 'tools#user'
  get 'tools/favorites/:user', to: 'tools#favorites'
end
