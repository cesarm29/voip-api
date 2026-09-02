class CreateCallLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :call_logs do |t|
      t.integer :caller_id
      t.integer :callee_id
      t.integer :room_id
      t.integer :duration
      t.datetime :started_at
      t.datetime :ended_at
      t.string :status

      t.timestamps
    end
  end
end
