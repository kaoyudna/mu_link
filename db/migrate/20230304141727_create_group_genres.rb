class CreateGroupGenres < ActiveRecord::Migration[6.1]
  def change
    create_table :group_genres do |t|
      t.integer :group_id, null: false
      t.integer :genre_id, null: false

      t.timestamps
    end
  end
end
