class BackgroundImage < ActiveRecord::Base
  belongs_to :song
  has_attached_file :image,
  :styles => {
    :tiny => "125x125",
    :small => "250x250",
    :medium => "500x500"
  }
  validates_attachment_content_type :image, :content_type => [/\Aimage/]
end
