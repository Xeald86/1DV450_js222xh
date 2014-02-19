class CreateLicences < ActiveRecord::Migration
  def change
    create_table :licences do |t|
      t.string "licence_type", :limit => 20, :null => false

      t.timestamps
    end
  end
end
