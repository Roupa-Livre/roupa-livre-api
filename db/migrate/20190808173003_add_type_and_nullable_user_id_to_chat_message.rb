class AddTypeAndNullableUserIdToChatMessage < ActiveRecord::Migration
  def change
    add_column :chat_messages, :type, :string, :default => 'ChatMessage'
    change_column_null :chat_messages, :user_id, true
    change_column_null :chat_messages, :message, true
  end
end
