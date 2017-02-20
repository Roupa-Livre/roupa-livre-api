class AddDeletedAtToChatApparel < ActiveRecord::Migration
  def change
    add_column :chat_apparels, :deleted_at, :datetime
    add_index :chat_apparels, :deleted_at
  end
end
