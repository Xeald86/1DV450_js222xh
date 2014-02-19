class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string "first_name", :limit => 20, :null => false
      t.string "last_name", :limit => 40, :null => false
      t.string "email", :default => "", :null => false
      t.string "password_digest", :null => false
      
      t.timestamps
    end
  end
end
