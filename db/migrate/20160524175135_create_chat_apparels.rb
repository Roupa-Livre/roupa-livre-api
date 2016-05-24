class CreateChatApparels < ActiveRecord::Migration
  def change
    create_table :chat_apparels do |t|
      t.references :chat, index: true, foreign_key: true
      t.references :apparel, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
