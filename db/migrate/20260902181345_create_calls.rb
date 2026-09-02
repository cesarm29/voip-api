class CreateCalls < ActiveRecord::Migration[8.0]
  def change
    create_table :calls do |t|
      t.references :caller, polymorphic: true, null: false
      t.references :callee, polymorphic: true, null: false
      t.string :status, default: "pending"
      t.datetime :started_at
      t.datetime :ended_at
      t.integer :duration

      t.timestamps
    end
  end
end
