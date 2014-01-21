# This migration comes from spree_shopomob (originally 20140120130837)
class CreateSpreeSyncs < ActiveRecord::Migration
  def change
    create_table :spree_syncs do |t|
      t.string :title
      t.text :text
      t.string :app_id
      t.text :options

      t.timestamps
    end
  end
end
