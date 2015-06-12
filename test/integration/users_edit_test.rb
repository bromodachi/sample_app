require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:test)
  end
  
  test "unsuccessful edits" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: {
      name: " ", email: "foo@bar", password:"blah" , password_confirmation:"damn"
    }
    assert_template "users/edit"
  end
  
  test "successful edits with  friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "Bob Dillan"
    email = "bob@gmail.com"
    patch user_path(@user), user: {
      name: name, email: email, 
      password:"" , password_confirmation:""
    }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
    
  
end
