class CreateGlobalTags < ActiveRecord::Migration
  def change
    create_table :global_tags do |t|
      t.string :name
      t.string :descrition, null: true
      t.text :body, null: true

      t.timestamps null: false
    end
  end

  def data
    ApparelTag.all.distinct(:name).each do |tag|
      GlobalTag.create!(name: tag.name)
    end
  end
end
