class CreateGlobalTags < ActiveRecord::Migration
  def change
    create_table :global_tags do |t|
      t.string :name
      t.string :description, null: true
      t.text :body, null: true

      t.timestamps null: false
    end
  end

  def data
    ApparelTag.all.distinct(:name).each do |tag|
      GlobalTag.find_or_create_by!(name: tag[:name].downcase)
    end
  end
end
