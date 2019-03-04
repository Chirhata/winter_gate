Rails.application.routes.draw do
  get 'home/top'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "home/about"=>"home#about"
  get "home/rule"=>"home#rule"
  get "user/login"=>"user#login"
  get "user/join"=>"user#join"
  get "user/question"=>"user#question"
  post "user/mail_check"=>"user#mail_check"
  post "user/sign_in"=>"user#sign_in"
  post "user/login_check"=>"user#login_check"
  post "user/logout"=>"user#logout"
end
