class AddLastReadToChat < ActiveRecord::Migration
  def change
    add_column :chats, :user_1_last_read_at, :datetime
    add_column :chats, :user_2_last_read_at, :datetime
  end
end
