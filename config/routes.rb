Rails.application.routes.draw do
  get 'index/index'

  post 'webhook/twitter'

  post 'webhook/telegram'

  root 'index#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
