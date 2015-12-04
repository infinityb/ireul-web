class MetadataField < ActiveRecord::Base
  validates :name, presence: true
end
