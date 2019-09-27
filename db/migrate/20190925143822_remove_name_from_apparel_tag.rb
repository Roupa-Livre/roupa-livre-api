class RemoveNameFromApparelTag < ActiveRecord::Migration
  def change
    change_column_null :apparel_tags, :global_tag_id, false
    remove_column :apparel_tags, :name, :string
  end

  def rollback
    ApparelTag.connection.update("update apparel_tags set name = global_tags.name from global_tags where global_tags.id = apparel_tags.global_tag_id")
  end
end
