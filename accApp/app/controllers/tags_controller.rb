class TagsController < ApplicationController
  
  before_filter :set_access_control_headers
  before_action :default_format_json
  before_filter :restrict_access
  before_filter :user_authentication_required, :except => [:index, :show]
    #before_filter :user_authentication_required
  
    respond_to :xml, :json
  
  def index
    if params[:resource_id]
      #/resources/_resource_id/tags/
      message = "All tags for a resource"
      tags = Resource.find_by_id(params[:resource_id]).tags
    else
      #/tags/
      message = "All tags"
      tags = Tag.all
    end
    #respond_with(@tags.limit(limit_param).offset(offset_param))
    
    data = tags.limit(limit_param()).offset(offset_param).map do |tag|
      format_data(tag)
    end
    
    result = {
      status: 200,
      message: message,
      count: tags.count,
      offset: offset_param,
      limit: limit_param,
		  items: data
    }
    
    respond_with result
  end
  
  def create
    t = Tag.new
    if params.has_key?(:tagName)
      t.tag = params[:tagName].capitalize
    end
    
    t_exist = Tag.find_by_tag(t.tag)
    
    if !t_exist.nil?
      tagExist(t_exist)
    else
      if t.valid?
        if t.save 
          respond_to do |format|
            format.json  {  render :json => {:response_code => 201, :message => "A new tag has been created", :tag => t, :link => tags_path + "/" + t.id.to_s()}, :status => 201 }
            format.xml  {  render :xml => {:response_code => 201, :message => "A new tag has been created", :tag => t, :link => tags_path + "/" + t.id.to_s()}, :status => 201 }
          end
        else
          server_error
        end
      else
        validation_error(t)
      end
    end
  end
  
  def update
    tag = Tag.find_by(id: params[:id])
    if params.has_key?(:tagName)
      tag.tag = params[:tagName]
    end
    
    if tag.save
      created_success(201, 201, "Tag has been updated", tags_path + "/" + tag.id.to_s()) 
    else
      server_error
    end
  end
  
  def destroy
    if Tag.find_by(id: params[:id])
      t = Tag.find_by(id: params[:id])
      t.destroy
      created_success(200, 200, "Tag deleted", "")
    else
      no_content
    end
  end
  
  def show
    #/tags/:id
    @tag = Tag.find_by_id(params[:id])
    if @tag != nil
      respond_with(@tag)
    else
      no_content
    end
  end
  
  private

  def tag_params
    params.require(:tag).permit(:tag)
  end

  def format_data(tag)
		data = {
        id: tag.id,
        tag: tag.tag,
        links: {
          self: "/tags/"+tag.id.to_s(),
          resources: "/tags/"+tag.id.to_s()+"/resources"
        }
		}
	end
end
