class AddGlobalTagToApparelTag < ActiveRecord::Migration
  def change
    add_reference :apparel_tags, :global_tag, index: true, foreign_key: true
  end
  
  def data
    ApparelTag.connection.update("update apparel_tags set global_tag_id = global_tags.id from global_tags where lower(global_tags.name) = lower(apparel_tags.name)")
  end
end
