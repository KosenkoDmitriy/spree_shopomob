class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :imageName
      t.string :key
      t.string :value
      t.string :prefix
      t.string :contact_type

      t.timestamps
    end
  end
end
