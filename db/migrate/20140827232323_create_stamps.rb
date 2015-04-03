class CreateStamps < ActiveRecord::Migration
  def change
    create_table :stamps do |t|
      t.date :devkit
      t.boolean :damage
      t.boolean :giveaway

      t.timestamps
    end
  end
end
