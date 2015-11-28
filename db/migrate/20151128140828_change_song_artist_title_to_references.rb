class ChangeSongArtistTitleToReferences < ActiveRecord::Migration
  def change
    remove_column :songs, :artist
    remove_column :songs, :artist_id
    remove_column :songs, :title
    add_column :songs, :artist_metadata_id, :integer
    add_column :songs, :title_metadata_id, :integer
    add_index :songs, :artist_metadata_id
    add_index :songs, :title_metadata_id
  end
end
