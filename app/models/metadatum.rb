class Metadatum < ActiveRecord::Base
  belongs_to :song
  belongs_to :metadata_field

  validates :song_id, presence: true
  validates :metadata_field_id, presence: true
  validates :value, presence: true
end
