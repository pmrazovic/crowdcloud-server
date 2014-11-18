require 'test_helper'

class SensingTaskControllerTest < ActionController::TestCase
  setup do
    @sensing_task = sensing_tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sensing_tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sensing_task" do
    assert_difference('SensingTask.count') do
      post :create, sensing_task: {  }
    end

    assert_redirected_to sensing_task_path(assigns(:sensing_task))
  end

  test "should show sensing_task" do
    get :show, id: @sensing_task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sensing_task
    assert_response :success
  end

  test "should update sensing_task" do
    patch :update, id: @sensing_task, sensing_task: {  }
    assert_redirected_to sensing_task_path(assigns(:sensing_task))
  end

  test "should destroy sensing_task" do
    assert_difference('SensingTask.count', -1) do
      delete :destroy, id: @sensing_task
    end

    assert_redirected_to sensing_tasks_path
  end
end
