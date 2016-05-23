class AddSortOrderToImage < ActiveRecord::Migration
  def change
    add_column :apparel_images, :sort_order, :integer
  end
end
