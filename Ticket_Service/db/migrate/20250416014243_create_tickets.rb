class CreateTickets < ActiveRecord::Migration[7.2]
  def change
    create_table :tickets do |t|
      t.datetime :event_date
      t.float :current_price
      t.string :status
      t.references :ticket_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
