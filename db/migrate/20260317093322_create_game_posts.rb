class CreateGamePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :game_posts do |t|
      t.string :name
      t.string :location
      t.datetime :time_start
      t.datetime :time_end
      t.references :user_owner, null: false, foreign_key: {to_table: :users}
      t.string :image
      t.integer :num_needed
      t.integer :total_players
      t.text :description
      t.text :details
      t.datetime :cutoff_time
      t.integer :status

      t.timestamps
    end
  end
end
