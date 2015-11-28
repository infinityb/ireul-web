class DropMetadataFromSongs < ActiveRecord::Migration
  def change
    remove_column :songs, :metadata
  end
end
