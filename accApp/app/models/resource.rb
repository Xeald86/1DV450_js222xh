class Resource < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  
  belongs_to :resource_type
  belongs_to :licence
  belongs_to :user
  has_and_belongs_to_many :tags
  
  validates :name,
  :presence => { :message => "A name for the resource is required" },
  :length => { :minimum => 5, :message => "Your resource-name needs to be at least 5 chars long" }
  
  validates :description,
  :presence => { :message => "A short description for the resource is required" },
  :length => { :minimum => 10, :message => "Your description needs to be at least 10 chars long" }
  
  validates :url,
  :presence => { :message => "A url for the resource is required" },
  :length => { :minimum => 10, :message => "Your url needs to be at least 10 chars long" }
  
  validates :user_id,
  :presence => { :message => "No user can be found as the creator of this resource" }
  
  def as_json(options={})
    super(options.merge(
      :except => [:updated_at, :licence_id, :tag_id, :user_id, :resource_type_id],
        #:include => [:tags, :resource_type, :licence, :user],
        :include => [],
        :methods => [:links]
      ))
  end
  
  def to_xml(options={})
    super(options.merge(
      :except => [:updated_at, :licence_id, :tag_id, :user_id, :resource_type_id],
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