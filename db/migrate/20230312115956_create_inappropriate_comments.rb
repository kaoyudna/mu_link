class CreateInappropriateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :inappropriate_comments do |t|
      t.string :comment

      t.timestamps
    end
  end
end
