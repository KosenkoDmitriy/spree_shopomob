class CreateAbouts < ActiveRecord::Migration
  def change
    create_table :abouts do |t|
      t.string :imageName
      t.string :title
      t.string :text
      t.string :text

      t.timestamps
    end
  end
end
