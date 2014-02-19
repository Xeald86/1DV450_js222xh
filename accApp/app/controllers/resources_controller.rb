class ResourcesController < ApplicationController
  
  before_action :default_format_json
  before_filter :restrict_access
  
  respond_to :xml, :json
  
  def index
    if params[:user_id]
      #/users/:user_id/resources/
      @resources = Resource.find_all_by_user_id(params[:user_id])
    elsif params[:licence_id]
      #/licences/:licence_id/resources/
      @resources = Resource.find_all_by_licence_id(params[:licence_id])
    elsif params[:resource_type_id]
      #/resource_types/:resource_type_id/resources/
      @resources = Resource.find_all_by_resource_type_id(params[:resource_type_id])
    elsif params[:tag_id]
      #/tags/:tag_id/resources/
      @tag = Tag.find_by_id(params[:tag_id])
      @resources = @tag.resources
    else
      #/resources/
      @resources = Resource.all
    end
    respond_with(@resources)
  end
  
  def show
    #/resources/:id
    @resource = Resource.find_by_id(params[:id])
    respond_with(@resource)
  end
end
