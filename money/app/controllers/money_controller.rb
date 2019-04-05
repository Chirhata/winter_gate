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
    @user = User.find_by(id: session[:user_id])
    target_day = @user.money_limit_day
    time = Time.now
    if time.day >= target_day.day
      if time.month == 12
        if Date.valid_date?(time.year + 1, 1, target_day.day) == true
          date_set = Date.new(time.year + 1, 1, target_day.day)
        else
          date_set = Date.new(time.year + 1, 1, 25)
        end
      else
        if Date.valid_date?(time.year, time.month + 1, target_day.day) == true
          date_set = Date.new(time.year, time.month + 1, target_day.day)
        else
          date_set = Date.new(time.year, time.month + 1, 25)
        end
      end
    else
      if Date.valid_date?(time.year, time.month, target_day.day) == true
        date_set = Date.new(time.year, time.month, target_day.day)
      else
        date_set = Date.new(time.year, time.month, 25)
      end
    end
    if date_set.month <10
      if date_set.day < 10
        @target_day = "#{date_set.year}0#{date_set.month}0#{date_set.day}".to_i
      else
        @target_day = "#{date_set.year}0#{date_set.month}#{date_set.day}".to_i
      end
    else
      if date_set.day < 10
        @target_day = "#{date_set.year}#{date_set.month}0#{date_set.day}".to_i
      else
        @target_day = "#{date_set.year}#{date_set.month}#{date_set.day}".to_i
      end
    end
  end

  def tomonth_target
    @user = User.find_by(id: session[:user_id])
    target_day = params[:user][:money_limit_day]
    @money_limit = params[:user][:money_limit].to_i
    @money_limit -= params[:user][:income].to_i
    time = Time.now
    if time.month <10
      if time.day < 10
        today = "#{time.year}0#{time.month}0#{time.day}".to_i
      else
        today = "#{time.year}0#{time.month}#{time.day}".to_i
      end
    else
      if time.day < 10
        today = "#{time.year}#{time.month}0#{time.day}".to_i
      else
        today = "#{time.year}#{time.month}#{time.day}".to_i
      end
    end
    target_day_length = target_day.length
    p target_day[0,target_day_length - 4].to_i
    p target_day[target_day_length - 4,2].to_i
    p target_day[target_day_length - 2,2].to_i
    if today > target_day.to_i
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
        @user.money_limit_day = Time.zone.local(target_day[0,target_day_length - 4].to_i, target_day[target_day_length - 4,2].to_i, target_day[target_day_length - 2,2].to_i)
        @user.money_limit = @money_limit
        @user.income = params[:user][:income].to_i
        @user.money_limit_origin = @money_limit
        @user.save
        redirect_to("/user/#{@user.id}/top")
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
    target_day = params[:user][:money_limit_day]
    time = Time.now
    if time.month <10
      if time.day < 10
        today = "#{time.year}0#{time.month}0#{time.day}".to_i
      else
        today = "#{time.year}0#{time.month}#{time.day}".to_i
      end
    else
      if time.day < 10
        today = "#{time.year}#{time.month}0#{time.day}".to_i
      else
        today = "#{time.year}#{time.month}#{time.day}".to_i
      end
    end
    target_day_length = target_day.length
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
    if params[:user][:money_limit_day].empty? != true
      if today > target_day.to_i
        @user = User.new
        @error_message = "目標日は今日より後の日付に設定してください。"
        render("/money/money_form_tomonth")
        return
      else
        @user.money_limit_day = Time.zone.local(target_day[0,target_day_length - 4].to_i, target_day[target_day_length - 4,2].to_i, target_day[target_day_length - 2,2].to_i)
      end
    end
    if @user.save
      redirect_to("/user/#{@user.id}/top")
    end
  end
end