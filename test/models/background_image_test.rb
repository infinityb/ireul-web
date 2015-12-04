require 'test_helper'

class BackgroundImageTest < ActiveSupport::TestCase
  include ImageHelper

  setup do
    @song = songs(:songs_001)
  end

  test "it generates thumbnails" do
    image = get_test_image("a.jpg")
    bgi = BackgroundImage.create(song: @song, image: image)
    assert(bgi.valid?)
    refute_nil(bgi.image.url)
    refute_nil(bgi.image.url(:tiny))
    refute_nil(bgi.image.url(:small))
    refute_nil(bgi.image.url(:medium))
  end

  test "it obfuscates filenames" do
    filename = "a.jpg"
    image = get_test_image(filename)
    bgi = BackgroundImage.create(song: @song, image: image)
    bgi.image.url.match(/^.*\/system\/(.*\.jpg).*$/)
    obfuscated_filename = $1
    refute_equal(filename, obfuscated_filename)
  end

  test "it takes in JPEGs" do
    image = get_test_image("a.jpg")
    assert_difference('BackgroundImage.count') do
      BackgroundImage.create(song: @song, image: image)
    end
  end

  test "it takes in PNGs" do
    image = get_test_image("b.png")
    assert_difference('BackgroundImage.count') do
      BackgroundImage.create(song: @song, image: image)
    end
  end

  test "it takes in PNG8s" do
    image = get_test_image("c_png8.png")
    assert_difference('BackgroundImage.count') do
      BackgroundImage.create(song: @song, image: image)
    end
  end

  test "it takes in GIFs" do
    image = get_test_image("d.gif")
    assert_difference('BackgroundImage.count') do
      BackgroundImage.create(song: @song, image: image)
    end
  end

  test "it rejects garbage images" do
    garbage = File.new("test/fixtures/metadata_fields.yml")
    assert_no_difference('BackgroundImage.count') do
      BackgroundImage.create(song: @song, image: garbage)
    end
  end

  test "it validates presence of song" do
    image = get_test_image("d.gif")
    assert_no_difference('BackgroundImage.count') do
      BackgroundImage.create(song: nil, image: image)
    end
  end

  test "it validates presence of image" do
    assert_no_difference('BackgroundImage.count') do
      BackgroundImage.create(song: @song, image: nil)
    end
  end
end
