class CreateMetadata < ActiveRecord::Migration
  def change
    create_table :metadata do |t|
      t.references :song, index: true, foreign_key: true
      t.references :metadata_field, index: true, foreign_key: true
      t.string :value

      t.timestamps null: false
    end
  end
end
