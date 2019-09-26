class CreateCustomNotifications < ActiveRecord::Migration
  def change
    create_table :custom_notifications do |t|
      t.string :push_title, null: false
      t.string :push_message, null: false
      t.string :title, null: false
      t.string :image_url
      t.text :body
      t.string :action_link
      t.string :action_title
      t.datetime :sent_at

      t.timestamps null: false
    end
  end
end
