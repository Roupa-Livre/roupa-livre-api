require 'test_helper'

class Web::GlobalTagsControllerTest < ActionController::TestCase
  setup do
    @web_global_tag = web_global_tags(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:web_global_tags)
  end

  test "should create web_global_tag" do
    assert_difference('Web::GlobalTag.count') do
      post :create, web_global_tag: { body: @web_global_tag.body, description: @web_global_tag.description, name: @web_global_tag.name }
    end

    assert_response 201
  end

  test "should show web_global_tag" do
    get :show, id: @web_global_tag
    assert_response :success
  end

  test "should update web_global_tag" do
    put :update, id: @web_global_tag, web_global_tag: { body: @web_global_tag.body, description: @web_global_tag.description, name: @web_global_tag.name }
    assert_response 204
  end

  test "should destroy web_global_tag" do
    assert_difference('Web::GlobalTag.count', -1) do
      delete :destroy, id: @web_global_tag
    end

    assert_response 204
  end
end
