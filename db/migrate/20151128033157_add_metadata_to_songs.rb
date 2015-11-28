class AddMetadataToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :metadata, :string
  end
end
