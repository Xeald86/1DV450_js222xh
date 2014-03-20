class ResourcesController < ApplicationController
  
  before_filter :set_access_control_headers
  before_action :default_format_json
  before_filter :restrict_access
  before_filter :user_authentication_required, :except => [:index, :show, :search]
  
  respond_to :xml, :json
  
  def index

      if params[:user_id]
        #/users/:user_id/resources/
        @user = User.find_by_id(params[:user_id])
        message = "All resources for a user"
        resources = @user.resources
      elsif params[:licence_id]
        #/licences/:licence_id/resources/
        @licence = Licence.find_by_id(params[:licence_id])
        message = "All resources with a licence"
        resources = @licence.resources
      elsif params[:resource_type_id]
        #/resource_types/:resource_type_id/resources/
        @rt = ResourceType.find_by_id(params[:resource_type_id])
        message = "All resources of a type"
        resources = @rt.resources
      elsif params[:tag_id]
        #/tags/:tag_id/resources/
        @tag = Tag.find_by_id(params[:tag_id])
        message = "All resources with a tag"
        resources = @tag.resources
      else
        #/resources/
        resources = Resource.all
        message = "All resources"
      end
      
      #respond_with(@resources.limit(limit_param).offset(offset_param))

      #Experimental
      
      data = resources.limit(limit_param()).offset(offset_param).map do |resource|
				format_data(resource)
			end
      
      result = {
					status: 200,
          message: message,
					count: resources.count,
          offset: offset_param,
          limit: limit_param,
				 	items: data
				}
      
      respond_with result
  end
  
  def search
    if params.has_key?(:search)
      resources = Resource.find(:all, :conditions => ['name LIKE ?', "%#{params[:search]}%"])
      #respond_with(@resources)
    
      data = resources.map do |resource|
				format_data(resource)
			end
      
      result = {
					status: 200,
          message: "Search-results",
					count: resources.count,
          offset: offset_param,
          limit: limit_param,
				 	items: data
				}
      
      respond_with result
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
          if !params[:tags].nil?
            params[:tags].each do |t|
              tag = Tag.find_by_id(t["id"])
              res.tags << tag
            end
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
    
    #Destroy all existing tags
    res.tags.destroy_all
    
    #Add tags that are given
    if params.has_key?(:tags)
      if !params[:tags].nil?
        params[:tags].each do |t|
          tag = Tag.find_by_id(t["id"])
          unless res.tags.include? tag
            res.tags << tag
          end
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

  def format_data(resource)
		data = {
        id: resource.id,
      user_id: resource.user.id,
        resource_type_id: resource.resource_type.id,
        licence_id: resource.licence.id,
				name: resource.name,
				description: resource.description,
				url: resource.url,
        tags: resource.tags,
        links: {
          self: "/resources/"+resource.id.to_s(),
            tags: "/resources/"+resource.id.to_s()+"/tags",
            user: "/resources/"+resource.id.to_s()+"/user",
            licence: "/resources/"+resource.id.to_s()+"/licence",
            resource_type: "/resources/"+resource.id.to_s()+"/resource_type"
        },
				created_at: resource.created_at,
				updated_at: resource.updated_at
		}

	end


end
