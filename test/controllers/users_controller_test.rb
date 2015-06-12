require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:test)
    @otherUser = users(:bob)
  end
  
  test "should redirect index when logged in" do
    get :index
    assert_redirected_to login_url
  end 
  test "invalid signup information" do
    get signup_path
      assert_no_difference 'User.count' do
        post users_path, user:{
          name: "", email: "foo@invalid", password: "", password_confirmation: "blah"
        }
      end
    assert_template 'users/new'
  end
  
  test "should redirectedit when not logged in" do
    get :edit, id:@user
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect update when not logged in" do
    patch :update, id: @user, user:{ name: @user.name, email: @user.email}
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  test "should redirect when wong user" do
    log_in_as(@otherUser)
    get :edit, id:@user
    assert flash.empty?
    assert_redirected_to root_url
  end
  test "should redirect updatewhen wong user" do
    log_in_as(@otherUser)
    patch :update, id: @user, user:{ name: @user.name, email: @user.email}
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end
      
  
  test "non-admin doing destroy, should redirect" do
    log_in_as(@otherUser)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end

end
