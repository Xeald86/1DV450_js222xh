class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
    
private
  
  def default_format_json
    if(
        (request.headers["HTTP_ACCEPT"].nil? && params[:format].nil?) ||
        (request.headers["HTTP_ACCEPT"] != "application/xml" && params[:format] != "xml")
      )
      request.format = "json"
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
    head :unauthorized unless api_key
  end
  
end
