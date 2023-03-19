class ChangeColumnDefaultToPostComments < ActiveRecord::Migration[6.1]
  def change
    change_column_default :post_comments, :is_deleted, from: nil, to: false
  end
end
