require 'test_helper'

class SongTest < ActiveSupport::TestCase
  include AudioHelper

  test "it validates presence of a file" do
    assert_no_difference('Song.count') do
      Song.create(file: nil)
    end
  end

  test "it validates valid sample rate of a file" do
    assert_difference('Song.count') do
      Song.create(file: get_test_audio('busysignal.ogg'))
    end
  end

  test "it validates invalid sample rate of a file" do
    assert_no_difference('Song.count') do
      Song.create(file: get_test_audio('bell44100.ogg'))
    end
  end
end
