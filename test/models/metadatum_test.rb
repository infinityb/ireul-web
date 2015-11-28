require 'test_helper'

class MetadatumTest < ActiveSupport::TestCase
  setup do
    @song = songs(:songs_001)
    @field = metadata_fields(:metadata_fields_001)
  end

  test "it creates" do
    assert_difference('Metadatum.count') do
      Metadatum.create(song: @song, metadata_field: @field, value: "my value")
    end
  end

  test "it ensures presense of song" do
    assert_no_difference('Metadatum.count') do
      Metadatum.create(song: nil, metadata_field: @field, value: "my value")
    end
  end

  test "it ensures presense of metadata_field" do
    assert_no_difference('Metadatum.count') do
      Metadatum.create(song: @song, metadata_field: nil, value: "my value")
    end
  end

  test "it ensure presence of a value" do
    assert_no_difference('Metadatum.count') do
      Metadatum.create(song: @song, metadata_field: @field, value: nil)
    end
  end
end
