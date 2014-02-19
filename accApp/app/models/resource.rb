class Resource < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  
  belongs_to :resource_type
  belongs_to :licence
  belongs_to :user
  has_and_belongs_to_many :tags
  
  def as_json(options={})
    super(options.merge(
      :except => [:created_at, :updated_at],
        #:include => [:tags, :resource_type, :licence, :user],
        :include => [],
        :methods => [:links]
      ))
  end
  
  def to_xml(options={})
    super(options.merge(
        :except => [:created_at, :updated_at],
        #:include => [:tags, :resource_type, :licence, :user],
        :include => [],
        :methods => [:links]
      ))
  end
  
  def links
    { :self => resource_path(self), 
      :tags => resource_tags_path(self), 
      :user => resource_user_path(self), 
      :licence => resource_licence_path(self), 
      :resource_type => resource_resource_type_path(self) }
  end
end