class AddDetailsToPostComments < ActiveRecord::Migration[6.1]
  def change
    add_column :post_comments, :is_deleted, :boolean
  end
end
