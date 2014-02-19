class CreateApplications < ActiveRecord::Migration
  def change
    create_table :applications do |t|
      t.string "email", :null => false
      t.string "password_digest", :null => false
      t.references :apikey
      
      t.timestamps
    end
  end
end
