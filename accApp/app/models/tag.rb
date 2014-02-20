class Tag < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  
  has_and_belongs_to_many :resources
  
  validates :tag,
  :uniqueness => true,
  :presence => { :message => "A tagname is required" },
  :length => { :minimum => 2, :message => "Your tag needs to be at least 2 chars long" }
  
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
