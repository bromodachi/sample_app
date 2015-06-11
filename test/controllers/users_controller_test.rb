require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "invalid signup information" do
    get signup_path
      assert_no_difference 'User.count' do
        post users_path, user:{
          name: "", email: "foo@invalid", password: "", password_confirmation: "blah"
        }
      end
    assert_template 'users/new'
  end

end
