class UsersController < ApplicationController
  
  before_action :default_format_json
  before_filter :restrict_access
  
  respond_to :xml, :json
  
  def index
    @users = User.all
    respond_with(@users)
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
    if params[:resource_id]
      #/resources/:resource_id/user/
      @user = Resource.find_by_id(params[:resource_id]).user
    elsif params[:id]
      #/users/:id
      @user = User.find_by_id(params[:id])
    end
    
    respond_with(@user)
  end
  
  
  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
