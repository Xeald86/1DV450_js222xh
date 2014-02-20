class Licence < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  
  has_many :resources
  
  validates :licence_type,
  :uniqueness => true,
  :presence => { :message => "A licence-type is required" },
  :length => { :minimum => 3, :message => "Your licence-type needs to be at least 3 chars long" }
  
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
