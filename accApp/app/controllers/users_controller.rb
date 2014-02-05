class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      redirect_to users_path
    else
      render :action => "new"
    end
    
  end

  def new
    @user = User.new
  end

  def show
  end
  
  
  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :app_name).merge(:api_key => SecureRandom.hex(11))
  end
end
