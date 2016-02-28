class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :facebook_hash
      t.string :twitter_hash
      t.string :password

      t.timestamps null: false
    end
  end
end
