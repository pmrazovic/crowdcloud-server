require 'test_helper'

class OpenCallsControllerTest < ActionController::TestCase
  setup do
    @open_call = open_calls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:open_calls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create open_call" do
    assert_difference('OpenCall.count') do
      post :create, open_call: {  }
    end

    assert_redirected_to open_call_path(assigns(:open_call))
  end

  test "should show open_call" do
    get :show, id: @open_call
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @open_call
    assert_response :success
  end

  test "should update open_call" do
    patch :update, id: @open_call, open_call: {  }
    assert_redirected_to open_call_path(assigns(:open_call))
  end

  test "should destroy open_call" do
    assert_difference('OpenCall.count', -1) do
      delete :destroy, id: @open_call
    end

    assert_redirected_to open_calls_path
  end
end
