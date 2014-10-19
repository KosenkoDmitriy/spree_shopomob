class CreateSpreeCategories < ActiveRecord::Migration
  def change
    create_table :spree_categories do |t|
      t.string :imageName
      t.string :title
      t.text :text

      t.timestamps
    end
  end
end
