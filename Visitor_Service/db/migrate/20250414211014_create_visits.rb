class CreateVisits < ActiveRecord::Migration[7.2]
  def change
    create_table :visits do |t|
      t.integer :ticket_id
      t.string :status

      t.timestamps
    end
  end
end
