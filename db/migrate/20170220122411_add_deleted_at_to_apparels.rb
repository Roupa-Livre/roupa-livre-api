class AddDeletedAtToApparels < ActiveRecord::Migration
  def change
    add_column :apparels, :deleted_at, :datetime
    add_index :apparels, :deleted_at
  end
end
