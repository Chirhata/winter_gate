class UserController < ApplicationController
  def login
  end
  def join
    flash[:notice] = nil
  end
  def sign_in
    @user_data = User.new(name: params[:name], email: params[:email])
    @name = User.find_by(name: @user_data.name)
    email = User.find_by(email: @user_data.email)
    if @user_data.save
      flash[:notice] = nil
      redirect_to("/user/set_password")
    else
      if @name == nil
        flash[:notice] = "ユーザーネームを入力してください。#{@user_data.name}"
      elsif email == nil
        flash[:notice] = "メールアドレスを入力してください。"
      else
        flash[:notice] = "そのメールアドレスはすでに使用されています。"
      end
      render("user/join")
    end
  end
  def password
    @user_data = User.new(o_password: params[:o_password], re_password: params[:re_password], question: params[:question], answer: params[:answer])
    @o_password = User.find_by(o_password: @user_data.o_password)
    @re_password = User.find_by(re_password: @user_data.re_password)
    @question = User.find_by(question: @user_data.question)
    if @user_data.save
      if @user_data.o_password != @user_data.re_password
        flash[:notice] = "入力した二つのパスワードが一致しません。"
        @user_data.destroy
        render("user/set_password")
      else
        redirect_to("/home/top")
      end
    else
      if @o_password == nil
        flash[:notice] = "パスワードを入力してください。"
      elsif @re_password == nil
        flash[:notice] = "確認用のパスワードを入力してください。"
      elsif @question == nil
        flash[:notice] = "秘密の質問を入力してください。"
      else
        flash[:notice] = "秘密の質問の答えを入力してください。"
      end
      render("user/set_password")
    end
  end
end
