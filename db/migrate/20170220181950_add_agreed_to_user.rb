class AddAgreedToUser < ActiveRecord::Migration
  def change
    add_column :users, :agreed, :boolean, null: false, default: false
    add_column :users, :agreed_at, :datetime, default: nil
  end
end
