class CreateTicketBlocks < ActiveRecord::Migration[7.2]
  def change
    create_table :ticket_blocks do |t|
      t.references :ticket, null: false, foreign_key: true
      t.datetime :blocked_at
      t.string :reason

      t.timestamps
    end
  end
end
