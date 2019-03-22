Rails.application.routes.draw do
  get 'home/top'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post "user/:id/edit_menu/password"=>"user#renew_password"
  post "user/:id/edit_menu/name"=>"user#renew_name"
  post "user/:id/edit_menu/question"=>"user#renew_question"
  post "user/:id/edit_menu/delete_account"=>"user#delete_check"
  post "user/:id/edit_menu/all_delete"=>"user#all_delete"
  get "user/:id/edit_menu/final_check"=>"user#final_check"
  get "user/:id/edit_menu/delete_account"=>"user#delete_account"
  get "user/:id/edit_menu/question"=>"user#edit_question"
  get "user/:id/edit_menu/name"=>"user#edit_name"
  get "user/:id/edit_menu/password"=>"user#edit_password"
  get "user/:id/edit_menu"=>"user#edit_menu"
  get "user/:id/top"=>"user#top"

  get "money/:id/form"=>"money#money_form"
  get "money/:id/form_tomonth"=>"money#money_form_tomonth"
  get "money/:id/log"=>"money#log"
  get "money/:id/edit_target"=>"money#edit_target"
  post "money/:id/form_tomonth"=>"money#tomonth_target"
  post "money/:id/form"=>"money#money_form_save"
  post "money/:id/edit_target_save"=>"money#edit_target_save"

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
