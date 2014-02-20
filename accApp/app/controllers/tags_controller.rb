class TagsController < ApplicationController
  
    before_action :default_format_json
  before_filter :restrict_access
  before_filter :user_authentication_required, :except => [:index, :show]
    #before_filter :user_authentication_required
  
    respond_to :xml, :json
  
  def index
    if params[:resource_id]
      #/resources/_resource_id/tags/
      @tags = Resource.find_by_id(params[:resource_id]).tags
    else
      #/tags/
      @tags = Tag.all
    end
    respond_with(@tags.limit(limit_param).offset(offset_param))
  end
  
  def create
    t = Tag.new
    if params.has_key?(:tagName)
      t.tag = params[:tagName]
    end
      if t.valid?
        if t.save
          created_success(201, 201, "A new tag has been created", tags_path + "/" + t.id.to_s()) 
        else
          server_error
        end
      else
        validation_error(t)
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

end
