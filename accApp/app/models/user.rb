class User < ActiveRecord::Base
  
  validates :first_name,
  :presence => { :message => "Du måste ange ett namn!" },
  :length => { :minimum => 2, :message => "Ditt namn måste bestå av minst 2 tecken!" }
  
  validates :last_name,
  :presence => { :message => "Du måste ange ett efternamn!" },
  :length => { :minimum => 2, :message => "Ditt efternamn måste bestå av minst 2 tecken!" }
  
  validates :email,
  :presence => { :message => "Du måste fylla i en epost!" },
  :length => { :minimum => 8, :message => "Din epost måste bestå av minst 8 tecken!" }
  
  validates :app_name,
  :presence => { :message => "Du måste ange ett namn på din applikation!" },
  :length => { :minimum => 3, :message => "Namnet på din applikation mpåste bestå av minst 3 tecken!" }
  
end
