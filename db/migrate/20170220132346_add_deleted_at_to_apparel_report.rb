class AddDeletedAtToApparelReport < ActiveRecord::Migration
  def change
    add_column :apparel_reports, :deleted_at, :datetime
    add_index :apparel_reports, :deleted_at
  end
end
