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
    @money_limit_day = Date.civil(params[:money][:"money_limit_day(1i)"].to_i, params[:money][:"money_limit_day(2i)"].to_i, params[:money][:"money_limit_day(3i)"].to_i)
    @money_limit = params[:money][:money_limit]
    time = Time.now
    p "-------"
    p @money_limit_day
    p "----"
    if time >= @money_limit_day
      @money = User.new
      @error_message = "目標日は今日より後の日付に設定してください。"
      render("/money/money_form_tomonth")
    else
      @money.money_limit_day = @money_limit_day
      @money.money_limit = @money_limit
      @money.save
      redirect_to("/user/#{@user_data.id}/top")
    end
  end
end