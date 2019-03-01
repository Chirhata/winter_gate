Rails.application.routes.draw do
  get 'home/top'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "home/about"=>"home#about"
  get "home/rule"=>"home#rule"
  get "user/login"=>"user#login"
  get "user/join"=>"user#join"
  post "user/sign_in"=>"user#sign_in"
  get "user/set_password"=>"user#set_password"
  post "user/password"=>"user#password"

end
