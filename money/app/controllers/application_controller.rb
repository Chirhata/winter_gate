class ApplicationController < ActionController::Base
    before_action :check_login_user
    def check_login_user
        @login_user = User.find_by(id: session[:user_id])
    end
    
    def ban_unlogin_user
        if @login_user == nil
            flash[:notice] = "ログインが必要です。"
            redirect_to("/user/login")
        end
    end
    
    def ban_login_user
        if @login_user
            flash[:notice] = "すでにログインしています。"
            redirect_to("/user/#{@login_user.id}/top")
        end
    end
end
