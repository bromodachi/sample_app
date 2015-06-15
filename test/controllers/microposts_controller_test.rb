require 'test_helper'

class MicropostsControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @micropost = microposts(:breakfast)
  end
  
  test "should redirect when not logged in" do
    assert_no_difference 'Micropost.count' do
      post :create, micropost: {content: "Lorem ipsum"}
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when not logged in" do
    
    assert_no_difference 'Micropost.count' do
      delete :destroy, id: @micropost
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:test))
    micropost = microposts(:random_post)
    assert_no_difference "Micropost.count" do
      delete :destroy, id: micropost
    end
    assert_redirected_to root_url
  end
end
