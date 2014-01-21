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
