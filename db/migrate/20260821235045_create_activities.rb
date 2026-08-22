class CreateActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :activities do |t|
      t.references :job, null: false, foreign_key: true
      t.integer :action_type
      t.datetime :occurred_at
      t.text :notes

      t.timestamps
    end
  end
end
