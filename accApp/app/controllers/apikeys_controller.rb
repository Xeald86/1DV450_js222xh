class ApikeysController < ApplicationController
  before_action :require_login
  #skip_before_action :require_login, only: [:new, :create]

  def show
    @app = current_app
    @apikey = @app.apikey.auth_token
  end
end
