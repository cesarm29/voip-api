class CreateRooms < ActiveRecord::Migration[8.1]
  def change
    create_table :rooms do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.boolean :active
      t.integer :max_participants

      t.timestamps
    end
  end
end
