class CreateSpreeShops < ActiveRecord::Migration
  def change
    create_table :spree_shops do |t|
      t.string :imageName
      t.string :title
      t.text :text

      t.timestamps
    end
  end
end
