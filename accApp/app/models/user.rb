class User < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  
  has_many :resources
  
  has_secure_password
  
  validates :first_name,
  :presence => { :message => "Du måste ange ett namn!" },
  :length => { :minimum => 2, :message => "Ditt namn måste bestå av minst 2 tecken!" }
  
  validates :last_name,
  :presence => { :message => "Du måste ange ett efternamn!" },
  :length => { :minimum => 2, :message => "Ditt efternamn måste bestå av minst 2 tecken!" }
  
  validates :email,
  :uniqueness => true,
  :presence => { :message => "Du måste fylla i en epost!" },
  :length => { :minimum => 8, :message => "Din epost måste bestå av minst 8 tecken!" }
  
  validates_format_of :email,
  :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
  :presence => { :message => "Du har inte angivit en giltig epost" }


  
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
