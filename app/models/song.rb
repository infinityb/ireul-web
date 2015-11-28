class Song < ActiveRecord::Base
  serialize :metadata, Hash
  validates :metadata, presence: true

  has_attached_file :file
  validates_attachment_file_name :file, matches: [/ogg\Z/]
  validates_attachment_content_type :file, content_type: ["audio/ogg", "video/ogg"]

  def artist()
    self.metadata["ARTIST"]
  end

  def album()
    self.metadata["ALBUM"]
  end

  def title()
    self.metadata["TITLE"]
  end

  def enqueue()
    oggfile = open(self.file.path, 'rb')
    oggbuf = oggfile.read()
    oggfile.close()
    IreulWeb::Application.ireul_client.enqueue(oggbuf)
  end
end
