class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.references :artist, index: true, foreign_key: true
      t.string :title

      t.timestamps null: false
    end
  end
end
