class CreateBackgroundImages < ActiveRecord::Migration
  def change
    create_table :background_images do |t|
      t.references :song, index: true, foreign_key: true
      t.attachment :image

      t.timestamps null: false
    end
  end
end
