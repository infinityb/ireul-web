class Song < ActiveRecord::Base
  has_attached_file :file
  validates_attachment_file_name :file, matches: [/ogg\Z/]
  validates_attachment_content_type :file, content_type: [
    'audio/ogg',
    'video/ogg',
    'audio/x-vorbis+ogg',
    'application/ogg'
  ]

  has_many :metadatum, dependent: :destroy
  has_one :metadata, foreign_key: 'artist_metadata_id'
  has_one :metadata, foreign_key: 'title_metadata_id'
  has_many :background_images, dependent: :destroy

  validates :file, presence: true
  validate :validate_sample_rate

  def artist
    m = Metadatum.find_by_id(artist_metadata_id)
    m.value unless m.nil?
  end

  def title
    m = Metadatum.find_by_id(title_metadata_id)
    m.value unless m.nil?
  end

  def can_request?
    min_gap = Rails.configuration.x.ireul['request_time_gap_min']
    last_requested_at.nil? ||
      (Time.zone.now - last_requested_at) > min_gap.minute
  end

  def can_request_at
    return Time.zone.now if last_requested_at.nil?

    min_gap = Rails.configuration.x.ireul['request_time_gap_min']
    last_requested_at + min_gap.minute
  end

  private

  def validate_sample_rate
    Ogg::Vorbis::Info.open(Paperclip.io_adapters.for(file).path) do |info|
      if info.sample_rate != 48_000
        errors[:file] << "Uploaded file has an unsupported sample rate: #{info.sample_rate}. " \
                         'Only 48kHz ogg are supported.'
      end
    end
  rescue StandardError => e
    Rails.logger.error(e)
    errors[:file] << 'Failed to validate file.'
    false
  end
end
