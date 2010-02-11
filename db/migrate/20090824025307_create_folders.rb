class CreateFolders < ActiveRecord::Migration
  def self.up
    create_table :folders do |t|
      t.string :title, :permalink
      t.boolean :visible, :default => true # visible, hidden
      t.text :description
      t.integer :parent_id
      t.integer :assets_count, :default => 0
      t.integer :position, :default => 1
      t.boolean :can_delete, :default => true
      t.timestamps
    end
    Folder.create(:title => "Top Folder", :permalink => "top-folder", :can_delete => false)
  end

  def self.down
    drop_table :folders
  end
end
