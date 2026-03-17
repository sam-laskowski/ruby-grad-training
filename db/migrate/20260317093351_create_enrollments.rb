class CreateEnrollments < ActiveRecord::Migration[7.2]
  def change
    create_table :enrollments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :game_post, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
