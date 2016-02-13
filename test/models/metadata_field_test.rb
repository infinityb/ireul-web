require 'test_helper'

class MetadataFieldTest < ActiveSupport::TestCase
  test 'it validates presence of name' do
    assert_no_difference('MetadataField.count') do
      MetadataField.create(name: nil)
    end
  end
end
