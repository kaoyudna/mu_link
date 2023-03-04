class CreateGroupMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :group_messages do |t|
      t.integer :user_id, null: false
      t.integer :group_id, null: false
      t.text :message, null: false

      t.timestamps
    end
  end
end
