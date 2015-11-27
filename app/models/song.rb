class Song < ActiveRecord::Base
  belongs_to :artist
  validates :artist_id, presence: true
  validates :title, presence: true
end
