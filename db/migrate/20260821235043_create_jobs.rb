class CreateJobs < ActiveRecord::Migration[8.1]
  def change
    create_table :jobs do |t|
      t.references :company, null: false, foreign_key: true
      t.string :title
      t.integer :status
      t.string :url
      t.string :location
      t.string :work_model
      t.string :salary_info
      t.date :applied_on
      t.text :notes

      t.timestamps
    end
  end
end
