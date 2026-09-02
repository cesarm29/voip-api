class CreateDevices < ActiveRecord::Migration[8.1]
  def change
    create_table :devices do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :sip_address
      t.string :ip_address
      t.string :status
      t.datetime :last_seen_at

      t.timestamps
    end
  end
end
