class FillDatabseWithExampleData < ActiveRecord::Migration
  def change
    #USER DATA -------------------------------
    User.create(
      :first_name => "Jacob", 
      :last_name => "Karlsson",
      :email => "Jacob@test.com",
      :password => "jacob123",
      :password_confirmation => "jacob123"
      )
    User.create(
      :first_name => "Jonas", 
      :last_name => "Larsson",
      :email => "Jonas@test.com",
      :password => "jonas123",
      :password_confirmation => "jonas123"
      )
    
    
    #LICENCE DATA ----------------------------
    Licence.create(:licence_type => "GNU")
    Licence.create(:licence_type => "MIT")
    
    
    #TAG DATA --------------------------------
    Tag.create(:tag => "Häftig")
    Tag.create(:tag => "Rolig")
    Tag.create(:tag => "Sport")
    Tag.create(:tag => "Hästar")
    Tag.create(:tag => "Strandfest")
    Tag.create(:tag => "Festival")
    Tag.create(:tag => "Helg")
    
    
    #RESCOURCE_TYPE DATA ---------------------
    ResourceType.create(:typeName => "Bild")
    ResourceType.create(:typeName => "Youtube")
    ResourceType.create(:typeName => "Text")
    
    
    #RESOURCE DATA ---------------------------
    @res1 = Resource.new
    @res1.name = "En rolig sommarfilm"
    @res1.description = "Detta är en video som jag tog i sommras när jag var ute med vännerna."
    @res1.url = "http://www.youtube.com/watch?v=kohD5z5mE0E&feature=youtu.be"
    @res1.user = User.find_by_id(1)
    @res1.tags << Tag.find_by_id(2)
    @res1.tags << Tag.find_by_id(5)
    @res1.tags << Tag.find_by_id(7)
    @res1.licence = Licence.last
    @res1.resource_type = ResourceType.find_by_id(2)
    @res1.save
    
    @res2 = Resource.new
    @res2.name = "I stallet på en fredag"
    @res2.description = "En bild som visar hur jag spenderar mina fredagar på stallet."
    @res2.url = "http://www.hammars.se/Horse/images/hast_stall.jpg"
    @res2.user = User.find_by_id(2)
    @res2.tags << Tag.find_by_id(3)
    @res2.tags << Tag.find_by_id(4)
    @res2.tags << Tag.find_by_id(7)
    @res2.licence = Licence.first
    @res2.resource_type = ResourceType.find_by_id(1)
    @res2.save
    
    @res3 = Resource.new
    @res3.name = "Hur du hackar ett wifi"
    @res3.description = "Beskrivande video på hur du går tillväga för att hacka ett wifi"
    @res3.url = "http://www.youtube.com/watch?v=kohD5z5mE0E&feature=youtu.be"
    @res3.user = User.find_by_id(2)
    @res3.tags << Tag.find_by_id(1)
    @res3.tags << Tag.find_by_id(2)
    @res3.licence = Licence.last
    @res3.resource_type = ResourceType.find_by_id(2)
    @res3.save
   
    #-----------------------------------------
  end
end
