class AddDescriptionToEntries < ActiveRecord::Migration[7.2]
  def change
    add_column :entries, :description, :string
  end
end
