class Tag < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  
  has_and_belongs_to_many :resources
  
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
    { :self => tag_path(self), 
      :resources => tag_resources_path(self) }
  end
end
