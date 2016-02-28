class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :name
      t.text :text
      t.boolean :done
      t.datetime :datetime
      t.belongs_to(:user, foreign_key: true)
      t.belongs_to(:priority, foreign_key: true)

      t.timestamps null: false
    end
  end
end
