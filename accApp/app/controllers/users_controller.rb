class UsersController < ApplicationController
  
  before_filter :set_access_control_headers
  before_action :default_format_json
  before_filter :restrict_access
  
  respond_to :xml, :json
  
  def index
    users = User.all
    #respond_with(@users.limit(limit_param).offset(offset_param))
    
    data = users.limit(limit_param()).offset(offset_param).map do |user|
      format_data(user)
    end
    
    result = {
      status: 200,
      message: 'All users',
      count: users.count,
      offset: offset_param,
      limit: limit_param,
		  items: data
    }
    
    respond_with result
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
  
  
  # Authentication methods ----------------------------
  
  #Client sends email + pass to see if its a valid to store
  def userAuth
   
    if params[:email] and params[:password]
      user = User.find_by_email(params[:email])
      if user && user.authenticate(params[:password])
        respond_to do |format|
          format.json  {  render :json => {:status => 200, :message => "Authentication accepted", :user => user}, :status => status }
          format.xml  {  render :xml => {:status => 200, :message => "Authentication accepted", :user => user}, :status => status }
        end
      else
        error(403, 403, "Not Authenticated")
      end
    else
      error(403, 403, "Not Authenticated")
    end
  end
  
  # ---------------------------------------------------
  
  
  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
  
  def format_data(user)
		data = {
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
        links: {
          self: "/users/"+user.id.to_s(),
          resources: "/users/"+user.id.to_s()+"/resources"
        }
		}
	end
end
