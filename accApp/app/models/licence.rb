class Licence < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  
  has_many :resources
  
  def as_json(options={})
    super(options.merge(
      :except => [:created_at, :updated_at],
        :include => [],
        :methods => [:links]
      ))
  end
  
  def to_xml(options={})
    super(options.merge(
        :except => [:created_at, :updated_at],
        :include => [],
        :methods => [:links]
      ))
  end
  
  def links
    { :self => licence_path(self), 
      :resources => licence_resources_path(self) }
  end
end
