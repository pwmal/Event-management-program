class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :document_number
      t.string :document_type
      t.string :full_name
      t.datetime :date_of_birth

      t.timestamps
    end
    add_index :users, :email
  end
end
