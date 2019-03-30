class MoneyController < ApplicationController
  require "active_support/time"
  before_action :ban_unlogin_user
  before_action :delete_session_for_change_password
  before_action :ban_set_target, {only: [:tomonth_target, :money_form_tomonth]}
  before_action :ban_unset_target, {only: [:money_form_save, :money_form, :edit_target, :edit_target_save]}
  def money_form
    @money = MoneyManagement.new
  end

  def money_form_tomonth
    @user = User.new
  end

  def tomonth_target
    @user = User.find_by(id: session[:user_id])
    @money_limit_day_y = params[:user]["money_limit_day(1i)"].to_i
    @money_limit_day_m = params[:user]["money_limit_day(2i)"].to_i
    @money_limit_day_d = params[:user]["money_limit_day(3i)"].to_i
    @money_limit = params[:user][:money_limit].to_i
    @money_limit -= params[:user][:income].to_i
    time = Time.now
    if time.year > @money_limit_day_y || time.month > @money_limit_day_m
      @user = User.new
      @error_message = "目標日は今日より後の日付に設定してください。"
      render("/money/money_form_tomonth")
      return
    else
      if time.day >= @money_limit_day_d && time.month == @money_limit_day_m
        @user = User.new
        @error_message = "目標日は今日より後の日付に設定してください。"
        render("/money/money_form_tomonth")
        return
      else
        if @money_limit <= 0
          @user = User.new
          @error_message = "そんな計画で大丈夫か？大丈夫じゃない、問題だ。"
          render("/money/money_form_tomonth")
          return
        else
          @user.money_limit_day_origin = Date.today
          @user.money_limit_day = Time.zone.local(params[:user]["money_limit_day(1i)"].to_i, params[:user]["money_limit_day(2i)"].to_i, params[:user]["money_limit_day(3i)"].to_i)
          @user.money_limit = @money_limit
          @user.income = params[:user][:income].to_i
          @user.money_limit_origin = @money_limit
          @user.save
          redirect_to("/user/#{@user.id}/top")
        end
      end
    end
  end

  def money_form_save
    @money = MoneyManagement.new(user_id: session[:user_id], income_and_spending: params[:money_management][:income_and_spending], use_for: params[:money_management][:use_for], income_or_supend: params[:money_management][:income_or_supend])
    @user = User.find_by(id: session[:user_id])
    if @money.save
      p @money.income_or_supend
      if @money.income_or_supend == "収入"
        if @user.money_limit + @money.income_and_spending <= 99999999
          @user.money_limit += @money.income_and_spending
        else 
          @user.money_limit = 99999999
        end
      else
        if @user.money_limit - @money.income_and_spending >= 0
          @user.money_limit -= @money.income_and_spending
        else
          @user.money_limit = 0
        end
      end
      @user.save
      @error_mesage = nil
      redirect_to("/user/#{@money.user_id}/top")
    else
      @money = MoneyManagement.new
      @error_message = "全てのフォームを埋めてください。"
      render("/money/money_form")
    end
  end

  def log
  end

  def edit_target
    @user = User.new
  end

  def edit_target_save
    @user = User.find_by(id: session[:user_id])
    @money_limit_day_y = params[:user]["money_limit_day(1i)"].to_i
    @money_limit_day_m = params[:user]["money_limit_day(2i)"].to_i
    @money_limit_day_d = params[:user]["money_limit_day(3i)"].to_i
    time = Time.now
    if params[:user][:money_limit].empty? != true
      if params[:user][:income].empty? != true
        @user.money_limit = (params[:user][:money_limit].to_i - (@user.money_limit_origin + @user.income)) - (params[:user][:income].to_i - @user.income.to_i) + @user.money_limit
        @user.money_limit_origin = params[:user][:money_limit].to_i - params[:user][:income].to_i
        if @user.money_limit <= 0
          @user = User.new
          @error_message = "そんな計画で大丈夫か？大丈夫じゃない、問題だ。"
          render("/money/edit_target")
          return
        end
      else
        @user.money_limit = (params[:user][:money_limit].to_i - (@user.money_limit_origin + @user.income)) + @user.money_limit
        @user.money_limit_origin = params[:user][:money_limit].to_i - @user.income
        if @user.money_limit <= 0
          @user = User.new
          @error_message = "そんな計画で大丈夫か？大丈夫じゃない、問題だ。"
          render("/money/edit_target")
          return
        end
      end
    end
    if params[:user][:income].empty? != true
      if params[:user][:money_limit].empty? == true
        @user.money_limit = @user.money_limit - (params[:user][:income].to_i - @user.income)
        @user.money_limit_origin = @user.money_limit_origin - (params[:user][:income].to_i - @user.income)
        if @user.money_limit <= 0
          @user = User.new
          @error_message = "そんな計画で大丈夫か？大丈夫じゃない、問題だ。"
          render("/money/edit_target")
          return
        end
      end
      @user.income = params[:user][:income].to_i
    end
    if time.year > @money_limit_day_y || time.month > @money_limit_day_m
      @user = User.new
      @error_message = "目標日は今日より後の日付に設定してください。"
      render("/money/edit_target")
      return
    else
      if time.day >= @money_limit_day_d && time.month == @money_limit_day_m
        @user = User.new
        @error_message = "目標日は今日より後の日付に設定してください。"
        render("/money/edit_target")
        return
      else
        @user.money_limit_day = Time.zone.local(params[:user]["money_limit_day(1i)"].to_i, params[:user]["money_limit_day(2i)"].to_i, params[:user]["money_limit_day(3i)"].to_i)
      end
    end
    if @user.save
      redirect_to("/user/#{@user.id}/top")
    end
  end
end