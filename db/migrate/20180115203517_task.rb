class Task < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :name

      t.datetime :deadline
      t.datetime :completed_at

      t.references :user, index: true, null: false

      t.timestamps null: false
    end

  end
end
