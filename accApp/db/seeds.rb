# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.delete_all

users = User.create([
  {
    first_name: 'Jimmy', 
    last_name: "Sigeklint", 
    app_name: "Jimmys applikation",
    api_key: "hjdgjhhe678t78d",
    email: "wester.jimmy@gmail.com"
  }, 
  {
    first_name: "Jessica", 
    last_name: "Hernandez", 
    app_name: "Jessicas applikation",
    api_key: "dhjis6y7d678f68d",
    email: "jessi.h@gmail.com"
  }])
