class AddGlobalTagToApparelTag < ActiveRecord::Migration
  def change
    add_reference :apparel_tags, :global_tag, index: true, foreign_key: true
  end
  
  def data
    GlobalTag.find_each do |tag|
      ApparelTag.where(name: tag.name).update_all(global_tag_id: tag.id)
    end
  end
end
