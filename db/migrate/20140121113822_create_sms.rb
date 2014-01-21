class CreateSms < ActiveRecord::Migration
  def change
    create_table :sms do |t|
      t.string :to
      t.text :from
      t.string :text
      t.string :userapp
      t.boolean :delivered

      t.timestamps
    end
  end
end
