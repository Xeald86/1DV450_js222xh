class ResourceType < ActiveRecord::Base
  has_many :resources
  
  def as_json(options={})
    super(options.merge(:except => [:created_at, :updated_at]))
  end
  
  def to_xml(options={})
    super(options.merge(:except => [:created_at, :updated_at]))
  end
end
