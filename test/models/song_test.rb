require 'test_helper'

class SongTest < ActiveSupport::TestCase
  test "it validates presence of a file" do
    assert_no_difference('Song.count') do
      Song.create(file: nil)
    end
  end
end
