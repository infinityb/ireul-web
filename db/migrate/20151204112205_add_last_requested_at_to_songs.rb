class AddLastRequestedAtToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :last_requested_at, :datetime
  end
end
