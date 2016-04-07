class CreateChatMessages < ActiveRecord::Migration
  def change
    create_table :chat_messages do |t|
      t.references :chat, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true, null: false
      t.text :message, null: false

      t.timestamps null: false
    end
  end
end
