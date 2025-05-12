class CreateTicketCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :ticket_categories do |t|
      t.string :name
      t.float :base_price

      t.timestamps
    end
  end
end
