class LicencesController < ApplicationController

  before_filter :set_access_control_headers
  before_action :default_format_json
  before_filter :restrict_access
  before_filter :user_authentication_required, :except => [:index, :show]
  
  respond_to :xml, :json
  
  def index
    #/licences/
    licences = Licence.all
    
    data = licences.limit(limit_param()).offset(offset_param).map do |licence|
      format_data(licence)
    end
    
    result = {
      status: 200,
      message: 'All licences',
      count: licences.count,
      offset: offset_param,
      limit: limit_param,
		  items: data
    }
    
    respond_with result
  end
  
  def create
    lic = Licence.new
    lic.licence_type = params[:licence_type]
    
    if lic.valid?
      if lic.save
        created_success(201, 201, "A new licence has been created", licences_path + "/" + lic.id.to_s()) 
      else
        server_error
      end
    else
      validation_error(lic)
    end
  end
  
  def update
    lic = Licence.find_by(id: params[:id])
    if params.has_key?(:licence_type)
      lic.licence_type = params[:licence_type]
    end
    
    if lic.save
      created_success(201, 201, "Licence has been updated", licences_path + "/" + lic.id.to_s()) 
    else
      server_error
    end
  end
  
  def destroy
    if Licence.find_by(id: params[:id])
      lic = Licence.find_by(id: params[:id])
      lic.destroy
      created_success(200, 200, "Licence deleted", "")
    else
      no_content
    end
  end
  
  def show
    if params[:resource_id]
      #/resources/:resource_id/licence/
      @licence = Resource.find_by_id(params[:resource_id]).licence
    else
      #/licences/:licence_id/
      @licence = Licence.find_by_id(params[:id])
    end
    if @licence != nil
      respond_with(@licence)
    else
      no_content
    end
  end
  
  private
  
  def format_data(licence)
		data = {
        id: licence.id,
        licence_type: licence.licence_type,
        links: {
          self: "/licences/"+licence.id.to_s(),
          resources: "/licences/"+licence.id.to_s()+"/resources"
        }
		}
	end
  
end
