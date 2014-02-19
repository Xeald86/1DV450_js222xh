class CreateResourceTypes < ActiveRecord::Migration
  def change
    create_table :resource_types do |t|
      t.string "typeName", :limit => 40, :null => false
      
      t.timestamps
    end
    
    add_index("resources", "resource_type_id")
  end
end
