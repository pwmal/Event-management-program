class CreateBookings < ActiveRecord::Migration[7.2]
  def change
    create_table :bookings do |t|
      t.datetime :reserved_at
      t.datetime :expires_at
      t.string :status
      t.references :ticket, null: false, foreign_key: true

      t.timestamps
    end
  end
end
