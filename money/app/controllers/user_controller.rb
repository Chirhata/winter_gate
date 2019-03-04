class UserController < ApplicationController
  def login
    flash[:notice] = nil
    if session[:user_mail]
      redirect_to("/home/top")
    end
  end
  def join
    if session[:user_mail]
      redirect_to("/home/top")
    end
    flash[:notice] = nil
  end
  def sign_in
    flash[:notice] = nil
    if session[:user_mail]
      redirect_to("/home/top")
    end
    @user_data = User.new(name: params[:name], email: params[:email], o_password: params[:o_password], re_password: params[:re_password], question: params[:question], answer: params[:answer])
    @o_password = User.find_by(o_password: @user_data.o_password)
    @re_password = User.find_by(re_password: @user_data.re_password)
    @email = User.find_by(email: @user_data.email)
    if @user_data.save
      if @user_data.o_password != @user_data.re_password
        flash[:notice] = "入力した二つのパスワードが一致しません。"
        @user_data.destroy
        render("user/join")
      else
        flash[:notice] = nil
        session[:user_mail] = @user_data.email
        redirect_to("/home/top")
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
    if session[:user_mail]
      redirect_to("/home/top")
    end
    @user_data = User.find_by(email: params[:email], o_password: params[:o_password])
    if @user_data
      session[:user_mail] = @user_data.email
      flash[:notice] = nil
      redirect_to("/home/top")
    else
      flash[:notice] = "メールアドレス、またはパスワードが間違っています。"
      render("user/login")
    end
  end
  def logout
    session[:user_mail] = nil
    redirect_to("/home/top")
  end
  def question
    flash[:notice] = nil
    if session[:user_mail]
      redirect_to("/home/top")
    end
  end
  def mail_check
    if session[:user_mail]
      redirect_to("/home/top")
    end
    @user_data = User.find_by(email: params[:email])
    if @flag == nil
      if @user_data
        @flag = "exist"
        flash[:notice] = "秘密の質問に解答してください"
        render("user/question")
      else
        flash[:notice] = "メールアドレスが間違っています。"
        render("user/question")
      end
    else
      @flag = "exist"
      if params[:answer] == @user_data.answer
        flash[:notice] = "正解"
      else
        flash[:notice] = "回答が間違っています"
      end
    end
  end
end
