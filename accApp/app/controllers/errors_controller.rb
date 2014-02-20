class ErrorsController < ApplicationController
  before_action :default_format_json
  respond_to :xml, :json
  
  def page_notFound
    not_found
  end
  
  def server_error
    server_error
  end
  
  def bad_request
    bad_request
  end
end
