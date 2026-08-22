class CreateContacts < ActiveRecord::Migration[8.1]
  def change
    create_table :contacts do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name
      t.string :title
      t.string :email
      t.string :phone
      t.text :notes

      t.timestamps
    end
  end
end
