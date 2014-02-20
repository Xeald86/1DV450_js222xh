class User < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  
  has_many :resources
  
  has_secure_password
  
  validates :first_name,
  :presence => { :message => "Firstname is required" },
  :length => { :minimum => 2, :message => "Your firstname is to short" }
  
  validates :last_name,
  :presence => { :message => "Lastname is required" },
  :length => { :minimum => 2, :message => "Your lastname is to short" }
  
  validates :email,
  :uniqueness => true,
  :presence => { :message => "Email is required" },
  :length => { :minimum => 8, :message => "Your email has to be longer then 8 char" }
  
  validates_format_of :email,
  :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
  :presence => { :message => "You have not entered a valid email" }
  
  def as_json(options={})
    super(options.merge(
      :except => [:password_digest, :id, :last_name, :created_at, :updated_at],
        :include => [],
        :methods => [:links]
      ))
  end
  
  def to_xml(options={})
    super(options.merge(
        :except => [:password_digest, :id, :last_name, :created_at, :updated_at],
        :include => [],
        :methods => [:links]
      ))
  end
  
  def links
    { :self => user_path(self), 
      :resources => user_resources_path(self) }
  end
end
