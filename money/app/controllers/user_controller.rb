class UserController < ApplicationController
  require "active_support/time"
  before_action :ban_login_user, {only: [:login, :join, :sign_in, :login_check]}
  before_action :ban_unlogin_user, {only: [:top, :edit_menu, :edit_name, :renew_name, :edit_password, :renew_password, :edit_question, :renew_quesiton, :delete_account, :delete_check, :final_check, :all_delete]}
  def login
    flash[:notice] = nil
  end

  def join
    flash[:notice] = nil
  end

  def sign_in
    flash[:notice] = nil
    date = Date.today
    @user_data = User.new(name: params[:name], email: params[:email], o_password: params[:o_password], re_password: params[:re_password], question: params[:question], answer: params[:answer], money_limit: 0, money_limit_day: date.yesterday)
    @email = User.find_by(email: params[:email])
    if @user_data.save
      if @user_data.o_password != @user_data.re_password
        flash[:notice] = "入力した二つのパスワードが一致しません。"
        @user_data.destroy
        render("user/join")
      else
        flash[:notice] = nil
        session[:user_id] = @user_data.id
        @user_money_data = MoneyManagement.new(id: @user_data.id, income_and_spending: 0, use_for: "初期データ登録")
        @user_money_data.save
        redirect_to("/user/#{@user_data.id}/top")
      end
    else
      if @email != nil
        flash[:notice] = "そのメールアドレスはすでに使用されています。"
      else
        flash[:notice] = "全てのフォームを埋めてください。"
      end
      render("user/join")
    end
  end

  def login_check
    flash[:notice] = nil
    @user_data = User.find_by(email: params[:email], o_password: params[:o_password])
    if @user_data
      session[:user_id] = @user_data.id
      flash[:notice] = nil
      redirect_to("/user/#{@user_data.id}/top")
    else
      flash[:notice] = "メールアドレス、またはパスワードが間違っています。"
      render("user/login")
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to("/home/top")
  end
 
  def question
    @user = User.new
  end

  def mail_check
    @ans = User.new
    if User.find_by(email: params[:user][:email])
      @user = User.find_by(email: params[:user][:email])
      @error_message = nil
      render("/user/question_ans")
    else
      @user = User.new
      @error_message = "入力したメールアドレスが間違っています。"
      render("/user/question")
    end
  end

  def question_ans
    @ans = User.find_by(email: @user.email)
  end

  def answer_check
    @user = User.find_by(email: params[:user][:email])
    @ans = User.find_by(email: params[:user][:email])
    if @ans.answer == params[:user][:answer]
      @ans = User.new
      render("/user/your_password")
    else
      @ans = User.new
      @error_message = "解答が間違っています。"
      render("/user/question_ans")
    end
  end

  def your_password
    @user = User.find_by(email: params[:user][:email])
  end

  def top
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
      @user.save
      redirect_to("/user/#{@user.id}/edit_menu")
    else
      @user = User.new
      @error_message = "名前を１文字以上で入力してください。"
      render("/user/edit_name")
    end
  end

  def edit_password
    @user = User.new
  end

  def renew_password
    @user = User.find_by(id: session[:user_id])
    if @user.o_password == params[:user][:name]
      if params[:user][:o_password].empty? == true|| params[:user][:re_password].empty? == true
        @user = User.new
        @error_message = "パスワードは１文字以上で入力してください。"
        render("/user/edit_password")
      else
        if params[:user][:o_password] == params[:user][:re_password]
          @user.o_password = params[:user][:o_password]
          @user.re_password = params[:user][:re_password]
          @user.save
          redirect_to("/user/#{@user.id}/edit_menu")
        else
          @user = User.new
          @error_message = "入力した二つのパスワードが一致しません。"
          render("/user/edit_password")
        end
      end
    else
      @user = User.new
      @error_message = "パスワードが間違っています。"
      render("/user/edit_password")
    end
  end

  def edit_question
    @user = User.new
  end

  def renew_question
    @user = User.find_by(id: session[:user_id])
    if @user.o_password == params[:user][:name]
      if params[:user][:question].empty? == true|| params[:user][:answer].empty? == true
        @user = User.new
        @error_message = "質問と答えは１文字以上で入力してください。"
        render("/user/edit_question")
      else
        @user.question = params[:user][:question]
        @user.answer = params[:user][:answer]
        @user.save
        redirect_to("/user/#{@user.id}/edit_menu")
      end
    else
      @user = User.new
      @error_message = "パスワードが間違っています。"
      render("/user/edit_question")
    end
  end

  def delete_account
    @user = User.new
  end

  def delete_check
    @user = User.find_by(id: session[:user_id])
    if @user.o_password == params[:user][:name]
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
    @user_money = MoneyManagement.where(id: session[:user_id])
    @user.destroy
    @user_money.delete_all
    session[:user_id] = nil
    redirect_to("/home/top")
  end
end