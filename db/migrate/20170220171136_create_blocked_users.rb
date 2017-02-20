class CreateBlockedUsers < ActiveRecord::Migration
  def change
    create_table :blocked_users do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :blocked_user_id

      t.timestamps null: false
    end
  end
end
