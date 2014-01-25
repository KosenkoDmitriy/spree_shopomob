class CreateSpreeAbouts < ActiveRecord::Migration
  def change
    create_table :spree_abouts do |t|
      t.string :imageName
      t.string :title
      t.text :text

      t.timestamps
    end
  end
end
