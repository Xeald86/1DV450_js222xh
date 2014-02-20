class ResourceType < ActiveRecord::Base
  has_many :resources
  
  validates :typeName,
  :uniqueness => true,
  :presence => { :message => "A type-name is required" },
  :length => { :minimum => 3, :message => "Your type-name needs to be at least 3 chars long" }
  
  def as_json(options={})
    super(options.merge(:except => [:created_at, :updated_at]))
  end
  
  def to_xml(options={})
    super(options.merge(:except => [:created_at, :updated_at]))
  end
end
