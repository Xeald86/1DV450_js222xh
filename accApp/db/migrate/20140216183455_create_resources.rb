class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.references :resource_type
      t.references :licence
      t.references :tag
      t.references :user
      
      t.string "name", :limit => 40, :null => false
      t.string "description", :null => false
      t.string "url", :limit => 150, :null => false
      
      t.timestamps
    end
  end
end
