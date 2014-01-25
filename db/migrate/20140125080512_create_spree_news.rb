class CreateSpreeNews < ActiveRecord::Migration
  def change
    create_table :spree_news do |t|
      t.string :imgName
      t.string :title
      t.text :text

      t.timestamps
    end
  end
end
