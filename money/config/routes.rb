Rails.application.routes.draw do
  get 'home/top'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post "user/:id/edit_menu/check_password"=>"user#check_password"
  post "user/:id/edit_menu/renew_password"=>"user#renew_password"
  post "user/:id/edit_menu/renew_name"=>"user#renew_name"
  get "user/:id/edit_menu/name"=>"user#edit_name"
  get "user/:id/edit_menu/password"=>"user#edit_password"
  get "user/:id/edit_menu"=>"user#edit_menu"
  get "user/:id/edit_menu/new_password"=>"user#new_password"
  get "user/:id/top"=>"user#top"
  get "home/about"=>"home#about"
  get "home/rule"=>"home#rule"
  get "user/login"=>"user#login"
  get "user/join"=>"user#join"
  get "user/question"=>"user#question"
  get "user/question_ans"=>"user#question_ans"
  get "user/your_password"=>"user#your_password"
  post "user/question_ans"=>"user#answer_check"
  post "user/question"=>"user#mail_check"
  post "user/sign_in"=>"user#sign_in"
  post "user/login_check"=>"user#login_check"
  post "user/logout"=>"user#logout"
end
