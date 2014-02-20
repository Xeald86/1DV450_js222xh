class ResourcesController < ApplicationController
  
  before_action :default_format_json
  before_filter :restrict_access
  before_filter :user_authentication_required, :except => [:index, :show]
  
  respond_to :xml, :json
  
  def index
    if params[:user_id]
      #/users/:user_id/resources/
      @user = User.find_by_id(params[:user_id])
      @resources = @user.resources
    elsif params[:licence_id]
      #/licences/:licence_id/resources/
      @licence = Licence.find_by_id(params[:licence_id])
      @resources = @licence.resources
    elsif params[:resource_type_id]
      #/resource_types/:resource_type_id/resources/
      @rt = ResourceType.find_by_id(params[:resource_type_id])
      @resources = @rt.resources
    elsif params[:tag_id]
      #/tags/:tag_id/resources/
      @tag = Tag.find_by_id(params[:tag_id])
      @resources = @tag.resources
    else
      #/resources/
      @resources = Resource.all
    end
    respond_with(@resources.limit(limit_param).offset(offset_param))
  end
  
  def search
    if params.has_key?(:search)
      @resources = Resource.find(:all, :conditions => ['name LIKE ?', "%#{params[:search]}%"])
      respond_with(@resources)
    else
    error(422, 422, "No search-word was sent")
    end
  end
  
  def create
    res = Resource.new
    res.name = params[:name]
    res.description = params[:description]
    res.url = params[:url]
    res.user_id = user_auth_id
    
    if params.has_key?(:licence_id)
      res.licence_id = params[:licence_id]
    end
    
    if params.has_key?(:resource_type_id)
      res.resource_type_id = params[:resource_type_id]
    end
    
    if res.valid?
      if res.save
        created_success(201, 201, "A new resource has been created", resources_path + "/" + res.id.to_s())
        if params.has_key?(:tags)
          params[:tags].each do |t|
            tag = Tag.find_by_id(t["tag_id"])
            res.tags << tag
          end
        end
      else
        server_error
      end
    else
      validation_error(res)
    end
  end
  
  def destroy
    if Resource.find_by(id: params[:id])
      res = Resource.find_by(id: params[:id])
      res.tags.destroy_all
      res.destroy
      created_success(200, 200, "Resource deleted", "")
    else
      no_content
    end
  end
  
  def update
    res = Resource.find_by(id: params[:id])
    
    if params.has_key?(:tags)
      res.tags.destroy_all
      params[:tags].each do |t|
        tag = Tag.find_by_id(t["tag_id"])
        unless res.tags.include? tag
          res.tags << tag
        end
      end
    end
    
    if Resource.update(params[:id], resource_params)
      created_success(201, 201, "Resource has been updated", resources_path + "/" + res.id.to_s())
    else
      server_error
    end
  end
  
  def show
    #/resources/:id
    @resource = Resource.find_by_id(params[:id])
    if @resource != nil
      respond_with(@resource)
    else
      no_content
    end
  end
  
  
  private

  def resource_params
    params.require(:resource).permit(:name, :description, :url, :licence_id, :resource_type_id)
  end


end
