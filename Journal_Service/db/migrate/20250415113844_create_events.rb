class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.integer :ticket_id
      t.string :full_name
      t.timestamp :time
      t.string :event_type
      t.string :status

      t.timestamps
    end
  end
end
