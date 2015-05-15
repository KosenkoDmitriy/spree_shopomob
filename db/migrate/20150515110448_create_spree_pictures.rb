class CreateSpreePictures < ActiveRecord::Migration
  def change
    create_table :spree_pictures do |t|
      t.string :title
      t.string :alt
      #t.integer :imageable_id
      #t.string  :imageable_type
      t.references :imageable, polymorphic: true, index: true
      t.timestamps null: false
    end
    #add_index :pictures, :imageable_id
  end
end
