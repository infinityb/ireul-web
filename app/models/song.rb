class Song < ActiveRecord::Base
  has_attached_file :file
  validates_attachment_file_name :file, matches: [/ogg\Z/]
  validates_attachment_content_type :file, content_type: [
    "audio/ogg",
    "video/ogg",
    "audio/x-vorbis+ogg",
    "application/ogg"
  ]

  has_many :metadatum, dependent: :destroy
  has_one :metadata, foreign_key: 'artist_metadata_id'
  has_one :metadata, foreign_key: 'title_metadata_id'
  has_many :background_images, dependent: :destroy

  validates :file, presence: true
  validate :validate_sample_rate

  def artist
    m = Metadatum.find_by_id(self.artist_metadata_id)
    m.value if !m.nil?
  end

  def title
    m = Metadatum.find_by_id(self.title_metadata_id)
    m.value if !m.nil?
  end

  def can_request?
    min_gap = Rails.configuration.x.ireul["request_time_gap_min"]
    self.last_requested_at.nil? ||
    (Time.zone.now - self.last_requested_at) > min_gap.minute
  end

  def can_request_at
    min_gap = Rails.configuration.x.ireul["request_time_gap_min"]
    if self.last_requested_at.nil?
      return Time.zone.now
    else
      self.last_requested_at + min_gap.minute
    end
  end

  private

  def validate_sample_rate
    Ogg::Vorbis::Info.open(Paperclip.io_adapters.for(self.file).path) do |info|
      if info.sample_rate != 48000
        self.errors[:file] << "Uploaded file has an unsupported sample rate: #{info.sample_rate}. Only 48kHz ogg are supported."
      end
    end
  rescue Exception => e
    Rails.logger.error(e)
    self.errors[:file] << "Failed to validate file."
    false
  end
end
