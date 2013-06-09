require 'test_helper'

class Manager::GosControllerTest < ActionController::TestCase
  setup do
    @manager_go = manager_gos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manager_gos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manager_go" do
    assert_difference('Manager::Go.count') do
      post :create, manager_go: {  }
    end

    assert_redirected_to manager_go_path(assigns(:manager_go))
  end

  test "should show manager_go" do
    get :show, id: @manager_go
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manager_go
    assert_response :success
  end

  test "should update manager_go" do
    put :update, id: @manager_go, manager_go: {  }
    assert_redirected_to manager_go_path(assigns(:manager_go))
  end

  test "should destroy manager_go" do
    assert_difference('Manager::Go.count', -1) do
      delete :destroy, id: @manager_go
    end

    assert_redirected_to manager_gos_path
  end
end
