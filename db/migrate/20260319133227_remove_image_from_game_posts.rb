class RemoveImageFromGamePosts < ActiveRecord::Migration[7.2]
  def change
    remove_column :game_posts, :image, :string
  end
end
