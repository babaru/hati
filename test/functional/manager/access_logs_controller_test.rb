require 'test_helper'

class Manager::AccessLogsControllerTest < ActionController::TestCase
  setup do
    @manager_access_log = manager_access_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manager_access_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manager_access_log" do
    assert_difference('Manager::AccessLog.count') do
      post :create, manager_access_log: {  }
    end

    assert_redirected_to manager_access_log_path(assigns(:manager_access_log))
  end

  test "should show manager_access_log" do
    get :show, id: @manager_access_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manager_access_log
    assert_response :success
  end

  test "should update manager_access_log" do
    put :update, id: @manager_access_log, manager_access_log: {  }
    assert_redirected_to manager_access_log_path(assigns(:manager_access_log))
  end

  test "should destroy manager_access_log" do
    assert_difference('Manager::AccessLog.count', -1) do
      delete :destroy, id: @manager_access_log
    end

    assert_redirected_to manager_access_logs_path
  end
end
