class LicencesController < ApplicationController
  
  before_action :default_format_json
  before_filter :restrict_access
  
  respond_to :xml, :json
  
  def index
    #/licences/
    @licences = Licence.all
    respond_with(@licences)
  end
  
  def show
    if params[:resource_id]
      #/resources/:resource_id/licence/
      @licence = Resource.find_by_id(params[:resource_id]).licence
    else
      #/licences/:licence_id/
      @licence = Licence.find_by_id(params[:id])
    end
    respond_with(@licence)
  end
end
