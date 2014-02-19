class CreateApikeys < ActiveRecord::Migration
  def change
    create_table :apikeys do |t|
      t.string "auth_token", :null => false
      
      t.timestamps
    end
  end
end
