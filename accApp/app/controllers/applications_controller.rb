class ApplicationsController < ApplicationController
  def show
  end

  def create
    a = Application.new(app_params)
    key = Apikey.create!
    a.apikey = key
    @app = a
    
    if @app.save
      session[:appid] = @app.id
      redirect_to apikey_path
    else
      render :action => "new"
    end    
  end

  def new
    @app = Application.new
  end

  def index
  end
  
  # Authentication methods ----------------------------
  
  def login
    a = Application.find_by_email(params[:email])
    if a && a.authenticate(params[:password])
      session[:appid] = a.id
      redirect_to apikey_path
    else
      flash[:error] = "Email or Password was incorrect!"
      redirect_to root_path
    end
  end
  
  def logout
    session[:appid] = nil
    flash[:message] = "You have been logged out"
    redirect_to root_path
  end
  
  # ---------------------------------------------------
  
  private

  def app_params
    params.require(:application).permit(:email, :password, :password_confirmation)
  end
end
