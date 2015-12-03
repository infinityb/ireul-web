class Song < ActiveRecord::Base
  has_attached_file :file
  validates_attachment_file_name :file, matches: [/ogg\Z/]
  validates_attachment_content_type :file, content_type: ["audio/ogg", "video/ogg"]

  has_many :metadatum, dependent: :destroy
  has_one :metadata, foreign_key: 'artist_metadata_id'
  has_one :metadata, foreign_key: 'title_metadata_id'

  has_many :background_images, dependent: :destroy

  def artist
    m = Metadatum.find_by_id(self.artist_metadata_id)
    m.value if !m.nil?
  end

  def title
    m = Metadatum.find_by_id(self.title_metadata_id)
    m.value if !m.nil?
  end
end
