class TagsController < ApplicationController
  
    before_action :default_format_json
    before_filter :restrict_access
  
    respond_to :xml, :json
  
  def index
    if params[:resource_id]
      #/resources/_resource_id/tags/
      @tags = Resource.find_by_id(params[:resource_id]).tags
    else
      #/tags/
      @tags = Tag.all
    end
    respond_with(@tags)
  end
  
  def show
    #/tags/:id
    @tag = Tag.find_by_id(params[:id])
    respond_with(@tag)
  end
end
