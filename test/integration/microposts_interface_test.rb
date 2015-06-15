require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user= users(:test)
  end
  
  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    #invalid
    assert_no_difference "Micropost.count" do
      post microposts_path, micropost: {content: "" }
    end
    
    assert_select'div.#error_explanation'
    
    #valid
    assert_difference "Micropost.count" do
      post microposts_path, micropost: {content: "this is a post"}
    end
    
    assert_redirected_to root_url
    follow_redirect!
    assert_match "this is a post", response.body
    
    #delete a post
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    #visit a different user
    get user_path(users(:lana))
    assert_select 'a', text: 'delete', count: 0
  end
      
end
