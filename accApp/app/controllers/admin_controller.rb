class AdminController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "admin"
  def index
    @apps = Application.all
  end

  def show
  end

  def destroy
    @app = Application.find_by_id(params[:id])
    @app.apikey.destroy
    @app.destroy
    flash[:message] = "Applikationen som tillhörde (" + @app.email + ") har raderats"  
    redirect_to admin_path
  end
end
