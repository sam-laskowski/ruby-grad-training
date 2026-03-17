class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :password_digest
      t.string :photo
      t.text :bio
      t.integer :games_joined_count, default: 0
      t.integer :total_accepted_count, default: 0

      t.timestamps
    end
    add_index :users, :username, unique: true
  end
end
