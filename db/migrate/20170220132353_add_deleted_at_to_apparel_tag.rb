class AddDeletedAtToApparelTag < ActiveRecord::Migration
  def change
    add_column :apparel_tags, :deleted_at, :datetime
    add_index :apparel_tags, :deleted_at
  end
end
