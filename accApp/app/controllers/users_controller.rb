class UsersController < ApplicationController
  
  before_action :default_format_json
  before_filter :restrict_access
  
  respond_to :xml, :json
  
  def index
    @users = User.all
    respond_with(@users.limit(limit_param).offset(offset_param))
  end

  def show
    if params[:resource_id]
      #/resources/:resource_id/user/
      @user = Resource.find_by_id(params[:resource_id]).user
    elsif params[:id]
      #/users/:id
      @user = User.find_by_id(params[:id])
    end
    if @user != nil
      respond_with(@user)
    else
      no_content
    end
  end
  
  
  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
