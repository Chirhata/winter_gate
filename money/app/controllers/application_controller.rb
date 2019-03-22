class ApplicationController < ActionController::Base
    before_action :check_login_user
    require "active_support/time"
    def check_login_user
        @login_user = User.find_by(id: session[:user_id])
        @date = Date.today
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

    def ban_unset_target
        if @login_user.money_limit_day >= @date
            redirect_to("/user/#{@login_user.id}/top")
        end
    end

    def ban_set_target
        if @login_user.money_limit_day < @date
            redirect_to("/user/#{@login_user.id}/top")
        end
    end
end
