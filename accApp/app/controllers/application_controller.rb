class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  
    
private
  
  def set_access_control_headers 
    headers['Access-Control-Allow-Origin'] = '*' 
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*' 
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization, x-email, x-password'
  end
  
  def default_format_json
    if(
        (request.headers["HTTP_ACCEPT"].nil? && params[:format].nil?) ||
        (request.headers["HTTP_ACCEPT"] != "application/xml" && params[:format] != "xml")
      )
      request.format = "json"
    end
  end
  
  def limit_param
    if(params[:limit].nil?)
      25
    else
      params[:limit]
    end
  end
  
  def offset_param
    if(params[:offset].nil?)
      0
    else
      params[:offset]
    end
  end
  
  def current_app
    @current_app ||= Application.find(session[:appid]) if session[:appid]
  end
  
  def require_login
    if current_app.nil? then
      flash[:error] = "Refused access! You are not signed in!"
      redirect_to root_path
    end
  end
    
  def restrict_access
    api_key = Apikey.find_by_auth_token(params[:key])
    error(403, 403, "Not Authenticated") unless api_key
    #head :unauthorized unless api_key
  end
    
  def user_authentication_required 
    user = User.find_by_email(request.headers['x-email'])
    if user && user.authenticate(request.headers['x-password'])
    else
      error(403, 403, "Not Authenticated")
    end
  end
    
  def user_auth_id
    user = User.find_by_email(request.headers['x-email'])
    if user && user.authenticate(request.headers['x-password'])
      user.id
    end
  end
    
  def error(status, code, message)
    respond_to do |format|
      format.json  {  render :json => {:response_type => "ERROR", :response_code => code, :message => message}, :status => status }
      format.xml  {  render :xml => {:response_type => "ERROR", :response_code => code, :message => message}, :status => status }
    end
  end
    
  def created_success(status, code, message, link)
    respond_to do |format|
      format.json  {  render :json => {:response_code => code, :message => message, :link => link}, :status => status }
      format.xml  {  render :xml => {:response_code => code, :message => message, :link => link}, :status => status }
    end
  end
    
  def validation_error(u)
    respond_to do |format|
      format.json { render :json => { :response_code => 422, :message => "Some errors where found that needs to be corrected", :errors => u.errors.messages }, :status => 422 }
      format.xml { render :xml => { :response_code => 422, :message => "Some errors where found that needs to be corrected", :errors => u.errors.messages }, :status => 422 }
    end
  end
    
  def tagExist(t)
    respond_to do |format| 
      format.json { render :json => { :response_code => 409, :message => "This tag already exist", :tag => t }, :status => 409 }
      format.xml { render :xml => { :response_code => 409, :message => "This tag already exist", :tag => t }, :status => 422 }
    end
  end
    
  def not_found
    error(404, 404, "Unknown Method")
  end
    
  def no_content
    error(204, 204, "No Content")
  end
    
    def bad_request
      error(400, 400, "Bad Request")
  end
    
  def server_error
    error(500, 500, "Internal Server Error")
  end
  
end
