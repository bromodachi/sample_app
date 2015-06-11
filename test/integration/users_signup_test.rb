require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: { name:  "",
                               email: "user@invalid",
                               password:              "foo",
                               password_confirmation: "bar" }
    end
    assert_template 'users/new'
  end
  
  test "valid signup" do
    get signup_path
    assert_difference 'User.count' do
      post user_path, user:{name: "User", email:"user@example.com", password:"foobar", password_confirmation:"foorbar"}
    end
    assert_template 'user/show'
  end
end
