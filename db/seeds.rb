# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

metadatum_fields = [
  "ARTIST",
  "TITLE",
  "ALBUM",
  "YEAR",
  "COMMENT",
  "GENRE",
  "TRACKNUMBER"
]

metadatum_fields.each do |f|
  MetadataField.create(name: f)
end
