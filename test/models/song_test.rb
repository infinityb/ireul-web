require 'test_helper'

class SongTest < ActiveSupport::TestCase
  include AudioHelper

  test 'it validates presence of a file' do
    assert_no_difference('Song.count') do
      Song.create(file: nil)
    end
  end

  test 'it validates valid sample rate of a file' do
    assert_difference('Song.count') do
      Song.create(file: get_test_audio('busysignal.ogg'))
    end
  end

  test 'it validates invalid sample rate of a file' do
    assert_no_difference('Song.count') do
      Song.create(file: get_test_audio('bell44100.ogg'))
    end
  end

  test 'it checks if it is able to be requested' do
    assert(Rails.configuration.x.ireul['request_time_gap_min'] > 0)
    song = songs(:songs_001)
    song.last_requested_at = DateTime.current

    refute(song.can_request?)
    assert(song.can_request_at > DateTime.current)
  end
end
