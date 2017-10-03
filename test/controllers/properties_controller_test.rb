# == Schema Information
#
# Table name: properties
#
#  id         :integer          not null, primary key
#  name       :string
#  code       :string
#  sort_order :integer
#  segment    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class PropertiesControllerTest < ActionController::TestCase
  setup do
    @property = properties(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:properties)
  end

  test "should create property" do
    assert_difference('Property.count') do
      post :create, property: { group_code: @property.group_code, name: @property.name, parent_id: @property.parent_id, sort_order: @property.sort_order }
    end

    assert_response 201
  end

  test "should show property" do
    get :show, id: @property
    assert_response :success
  end

  test "should update property" do
    put :update, id: @property, property: { group_code: @property.group_code, name: @property.name, parent_id: @property.parent_id, sort_order: @property.sort_order }
    assert_response 204
  end

  test "should destroy property" do
    assert_difference('Property.count', -1) do
      delete :destroy, id: @property
    end

    assert_response 204
  end
end
