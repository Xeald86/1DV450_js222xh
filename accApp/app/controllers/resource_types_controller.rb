class ResourceTypesController < ApplicationController
  
  before_action :default_format_json
  before_filter :restrict_access
  
  respond_to :xml, :json
  
  def index
    #/resource_types/
    @types = ResourceType.all
    respond_with(@types)
  end
  
  def show
    if params[:resource_id]
      #/resources/:resource_id/resource_type/
      @type = Resource.find_by_id(params[:resource_id]).resource_type
    else
      #/resource_types/:id/
      @type = ResourceType.find_by_id(params[:id])
    end
    respond_with(@type)
  end
end
