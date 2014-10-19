class CreateSpreeCategoriesShops < ActiveRecord::Migration
  def change
    create_table :spree_categories_shops do |t|

      t.timestamps
    end
  end
end
