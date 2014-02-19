class Application < ActiveRecord::Base
  
  has_secure_password
  
  belongs_to :apikey
  
  validates :email,
  :uniqueness => true,
  :presence => { :message => "Your email is not valid!" },
  :length => { :minimum => 8, :message => "Your email is not valid!" }
  
  validates_format_of :email,
  :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
  :presence => { :message => "You need to enter your email" }
  
end
