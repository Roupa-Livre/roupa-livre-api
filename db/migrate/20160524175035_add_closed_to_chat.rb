class AddClosedToChat < ActiveRecord::Migration
  def change
    add_column :chats, :closed, :boolean
    add_column :chats, :closed_at, :datetime
  end
end
