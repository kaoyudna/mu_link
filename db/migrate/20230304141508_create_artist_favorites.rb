class CreateArtistFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :artist_favorites do |t|
      t.integer :user_id, null: false
      t.string :artist_id, null: false

      t.timestamps
    end
  end
end
