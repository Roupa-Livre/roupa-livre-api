class RemoveNameFromApparelTag < ActiveRecord::Migration
  def change
    change_column_null :apparel_tags, :global_tag_id, false
    remove_column :apparel_tags, :name, :string
  end

  def rollback
    GlobalTag.find_each do |tag|
      ApparelTag.where(global_tag_id: tag.id).update_all(name: tag.name)
    end
  end
end
