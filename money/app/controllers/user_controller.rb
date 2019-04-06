class UserController < ApplicationController
  require "active_support/time"
  before_action :delete_session_for_change_password, {only: [:login, :join, :sign_in, :login_check, :logout, :top, :edit_menu, :edit_name, :renew_name, :edit_password, :renew_password, :edit_question, :renew_quesiton, :delete_account, :delete_check, :final_check, :all_delete]}
  before_action :ban_login_user, {only: [:login, :join, :sign_in, :login_check]}
  before_action :ban_unlogin_user, {only: [:top, :edit_menu, :edit_name, :renew_name, :edit_password, :renew_password, :edit_question, :renew_quesiton, :delete_account, :delete_check, :final_check, :all_delete]}
  def login
    flash[:notice] = nil
  end

  def join
    flash[:notice] = nil
  end

  def sign_in
    @error_message = nil
    date = Date.today
    if date.month == 1
      date_set = Date.new(date.year - 1, date.month - 1, 25)
    else
      date_set = Date.new(date.year, date.month - 1, 25)
    end
    @user_data = User.new(name: params[:name], email: params[:email], question: params[:question], answer: params[:answer], money_limit: 0, money_limit_day: date_set, income: 0, money_limit_origin: 0, money_limit_day_origin: date_set)
    @user_data.password = params[:o_password]
    @email = User.find_by(email: params[:email])
    if @user_data.save
      if params[:o_password] != params[:re_password]
        @error_message = "入力した二つのパスワードが一致しません。"
        @user_data.destroy
        render("user/join")
        return
      else
        @error_message = nil
        session[:user_id] = @user_data.id
        @user_money_data = MoneyManagement.new(id: @user_data.id, income_and_spending: 0, use_for: "初期データ登録")
        @user_money_data.save
        redirect_to("/user/#{@user_data.id}/top")
      end
    else
      p 1234567890
      if @user_data.email.empty? == true || @user_data.name.empty? == true || @user_data.question.empty? == true || @user_data.answer.empty? == true || params[:o_password].empty? == true || params[:re_password].empty? == true
        @error_message = "全てのフォームを埋めてください。"
      else 
        if @user_data.name.length > 20
          @error_message = "名前は２０文字以内にしてください。"
        else 
          if @email
            @error_message = "そのメールアドレスはすでに使用されています。"
          else 
            if @user_data.question.length > 140
              @error_message = "秘密の質問は１４０文字以内にしてください。"
            else
              if @user_data.answer.length > 140
                @error_message = "秘密の質問の答えは１４０文字以内にしてください。"
              end
            end
          end
        end
      end
      render("user/join")
      return
    end
  end

  def login_check
    @error_message = nil
    @user_data = User.find_by(email: params[:email])
    if @user_data && @user_data.authenticate(params[:o_password])
      session[:user_id] = @user_data.id
      @error_message = nil
      redirect_to("/user/#{@user_data.id}/top")
    else
      @error_message = "メールアドレス、またはパスワードが間違っています。"
      render("user/login")
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to("/home/top")
  end
 
  def question
    @user = User.new
    p "33333"
    p  @user
  end

  def mail_check
    @ans = User.new
    if User.find_by(email: params[:user][:email])
      @user = User.find_by(email: params[:user][:email])
      @error_message = nil
      session[:user_data_for_mailcheck] = @user.id
      redirect_to("/user/question_ans")
      return
    else
      @user = User.new
      @error_message = "入力したメールアドレスが間違っています。"
      render("/user/question")
      return
    end
  end

  def question_ans
    if session[:user_data_for_mailcheck] == nil
      redirect_to("/user/question")
      return
    end
    @ans =  User.find_by(id: session[:user_data_for_mailcheck])
  end

  def answer_check
    @user =  User.find_by(id: session[:user_data_for_mailcheck])
    @ans =  User.find_by(id: session[:user_data_for_mailcheck])
    p "--"
    if @ans.answer == params[:user][:answer]
      @user = User.find_by(id: session[:user_data_for_mailcheck])
      @ans = User.find_by(id: @user.id)
      session[:user_data_for_answercheck] = @user.id
      redirect_to("/user/your_password")
      return
    else
      p "ssss"
      @ans = User.new
      @error_message = "解答が間違っています。"
      render("/user/question_ans")
      return
    end
  end

  def your_password
    if session[:user_data_for_answercheck] == nil
      redirect_to("/user/question")
      return
    end
    @ans =  User.find_by(id: session[:user_data_for_answercheck])
  end

  def change_password
    @ans = User.find_by(id: session[:user_data_for_answercheck])
    if params[:user][:o_password] != params[:user][:re_password]
      @ans = User.new
      render("/user/your_password")
      return
    else
      if params[:user][:o_password].length <= 0 || params[:user][:re_password].length <= 0
        @ans = User.new
        render("/user/your_password")
        return
      else
      @ans.password = params[:user][:o_password]
      @ans.save
        if session[:user_id] == nil
          redirect_to("/user/login")
        else
          redirect_to("/user/#{@ans.id}/edit_menu")
        end
      end
    end
  end

  def top
    @user = User.find_by(id: session[:user_id])
    @warning = nil
    rest_day = @user.money_limit_day.to_date - Date.today
    period = @user.money_limit_day.to_date - @user.money_limit_day_origin.to_date
    if (period.to_f / 3 * 2 <= rest_day.to_f && @user.money_limit < @user.money_limit_origin / 3 * 2)
      @warning = "このままだとやばいぞww"
    else
      if (period.to_f / 2 <= rest_day.to_f && @user.money_limit < @user.money_limit_origin / 2)
        @warning = "このままだとやばいぞwww"
      else 
        if (period.to_f / 3 < rest_day.to_f && @user.money_limit < @user.money_limit_origin / 3)
          @warning = "このままだとやばいぞwwww"
        else
          if (period.to_f / 6 < rest_day.to_f && @user.money_limit < @user.money_limit_origin / 6)
            @warning = "このままだとやばいぞwwwww"
          else
            @warning = "気を抜くなよ"
          end
        end
      end
    end
    @over = @user.money_limit - @user.money_limit_origin
    gon.percentage = (@user.money_limit / @user.money_limit_origin.to_f) * 100
    @money = MoneyManagement.new
  end

  def edit_menu
  end

  def edit_name
    @user = User.new
  end

  def renew_name
    @user = User.find_by(id: session[:user_id])
    if params[:user][:name].empty? != true
      @user.name = params[:user][:name]
      if @user.save
        redirect_to("/user/#{@user.id}/edit_menu")
      else
        @user = User.new
        @error_message = "名前は２０文字以内にしてください。"
        render("/user/edit_name")
        return
      end
    else
      @user = User.new
      @error_message = "名前を１文字以上で入力してください。"
      render("/user/edit_name")
      return
    end
  end

  def edit_password
    @user = User.new
  end

  def renew_password
    @user = User.find_by(id: session[:user_id])
    if @user.authenticate(params[:user][:name])
      if params[:user][:o_password].empty? == true|| params[:user][:re_password].empty? == true
        @user = User.new
        @error_message = "パスワードは１文字以上で入力してください。"
        render("/user/edit_password")
        return
      else
        if params[:user][:o_password] == params[:user][:re_password]
          @user.password = params[:user][:o_password]
          @user.save
          redirect_to("/user/#{@user.id}/edit_menu")
        else
          @user = User.new
          @error_message = "入力した二つのパスワードが一致しません。"
          render("/user/edit_password")
          return
        end
      end
    else
      @user = User.new
      @error_message = "パスワードが間違っています。"
      render("/user/edit_password")
      return
    end
  end

  def edit_question
    @user = User.new
  end

  def renew_question
    @user = User.find_by(id: session[:user_id])
    if @user.authenticate(params[:user][:name])
        @user.question = params[:user][:question]
        @user.answer = params[:user][:answer]
      if @user.save
        redirect_to("/user/#{@user.id}/edit_menu")
      else
        @user = User.new
        @error_message = "質問と答えは１文字以上１４０文字以内で入力してください。"
        render("/user/edit_question")
        return
      end
    else
      @user = User.new
      @error_message = "パスワードが間違っています。"
      render("/user/edit_question")
      return
    end
  end

  def delete_account
    @user = User.new
  end

  def delete_check
    @user = User.find_by(id: session[:user_id])
    if @user.authenticate(params[:user][:name])
      redirect_to("/user/#{@user.id}/edit_menu/final_check")
    else
      @user = User.new
      @error_message = "パスワードが間違っています。"
      render("/user/delete_account")
    end
  end

  def final_check
    @user = User.new
  end

  def all_delete
    @user = User.find_by(id: session[:user_id])
    @user_money = MoneyManagement.where(user_id: session[:user_id])
    @user.destroy
    @user_money.delete_all
    session[:user_id] = nil
    redirect_to("/home/top")
  end
end