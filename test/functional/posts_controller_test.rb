require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  setup do
    @post = posts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create post" do
    assert_difference('Post.count') do
      post :create, post: { body: @post.body, is_scheduled: @post.is_scheduled, is_sent: @post.is_sent, scheduled_at: @post.scheduled_at, sent_at: @post.sent_at, weibo_created_at: @post.weibo_created_at, weibo_id: @post.weibo_id, weibo_url: @post.weibo_url }
    end

    assert_redirected_to post_path(assigns(:post))
  end

  test "should show post" do
    get :show, id: @post
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @post
    assert_response :success
  end

  test "should update post" do
    put :update, id: @post, post: { body: @post.body, is_scheduled: @post.is_scheduled, is_sent: @post.is_sent, scheduled_at: @post.scheduled_at, sent_at: @post.sent_at, weibo_created_at: @post.weibo_created_at, weibo_id: @post.weibo_id, weibo_url: @post.weibo_url }
    assert_redirected_to post_path(assigns(:post))
  end

  test "should destroy post" do
    assert_difference('Post.count', -1) do
      delete :destroy, id: @post
    end

    assert_redirected_to posts_path
  end
end
