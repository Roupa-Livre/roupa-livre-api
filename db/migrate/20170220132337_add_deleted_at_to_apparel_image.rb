class AddDeletedAtToApparelImage < ActiveRecord::Migration
  def change
    add_column :apparel_images, :deleted_at, :datetime
    add_index :apparel_images, :deleted_at
  end
end
