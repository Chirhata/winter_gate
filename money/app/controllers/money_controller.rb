class MoneyController < ApplicationController
  require "active_support/time"
  def money_form
    @money = MoneyManagement.new
  end
  def money_form_tomonth
    @money = User.new
  end
  def tomonth_target
    @money = User.find_by(id: session[:user_id])
    @money_limit_day_y = params[:user]["money_limit_day(1i)"].to_i
    @money_limit_day_m = params[:user]["money_limit_day(2i)"].to_i
    @money_limit_day_d = params[:user]["money_limit_day(3i)"].to_i
    @money_limit = params[:user][:money_limit]
    time = Time.now
    if time.year > @money_limit_day_y || time.month > @money_limit_day_m
      @money = User.new
      @error_message = "目標日は今日より後の日付に設定してください。"
      render("/money/money_form_tomonth")
    else
      if time.day >= @money_limit_day_d && time.month == @money_limit_day_m
        @money = User.new
        @error_message = "目標日は今日より後の日付に設定してください。"
        render("/money/money_form_tomonth")
      else
        @money.money_limit_day = Time.zone.local(params[:user]["money_limit_day(1i)"].to_i, params[:user]["money_limit_day(2i)"].to_i, params[:user]["money_limit_day(3i)"].to_i)
        @money.money_limit = @money_limit
        @money.save
        redirect_to("/user/#{@money.id}/top")
      end
    end
  end
  def money_form_save
    @money = MoneyManagement.new
  end
end