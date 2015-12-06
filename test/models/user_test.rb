require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "it creates" do
    assert_difference('User.count', 1) do
      User.create(name: 'user', password_digest: 'yummy')
    end
  end

  test "it ensures at least one user remains" do
    user = users(:one)
    User.delete_all
    User.create(name: user.name, password_digest: user.password_digest)
    assert_no_difference('User.count') do
      User.delete(1)
    end
  end
end
