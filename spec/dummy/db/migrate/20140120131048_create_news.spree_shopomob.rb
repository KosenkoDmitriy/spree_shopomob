# This migration comes from spree_shopomob (originally 20131221065056)
class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :imgName
      t.string :title
      t.string :text

      t.timestamps
    end
  end
end
