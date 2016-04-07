class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.integer :user_1_id, null: false
      t.integer :user_2_id, null: false
      t.boolean :user_1_accepted
      t.boolean :user_2_accepted

      t.timestamps null: false
    end
  end
end
