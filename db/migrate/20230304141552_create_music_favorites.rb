class CreateMusicFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :music_favorites do |t|
      t.integer :user_id, null: false
      t.string :music_id, null: false

      t.timestamps
    end
  end
end
