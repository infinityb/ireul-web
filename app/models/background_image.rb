class BackgroundImage < ActiveRecord::Base
  belongs_to :song
  has_attached_file :image
  validates_attachment_content_type :image, :content_type => [/\Aimage/]
end
