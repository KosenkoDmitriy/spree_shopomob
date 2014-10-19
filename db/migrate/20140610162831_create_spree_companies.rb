class CreateSpreeCompanies < ActiveRecord::Migration
  def change
    create_table :spree_companies do |t|
      t.string :imageName
      t.string :title
      t.text :text

      t.timestamps
    end
  end
end
