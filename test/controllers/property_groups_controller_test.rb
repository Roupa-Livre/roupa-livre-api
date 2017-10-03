# == Schema Information
#
# Table name: property_groups
#
#  id                 :integer          not null, primary key
#  code               :string
#  name               :string
#  prop_name          :string
#  property_segment   :string
#  sort_order         :integer
#  parent_id          :integer
#  property_filter    :boolean          default(FALSE)
#  filter_property_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class PropertyGroupsControllerTest < ActionController::TestCase
  setup do
    @property_group = property_groups(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:property_groups)
  end

  test "should create property_group" do
    assert_difference('PropertyGroup.count') do
      post :create, property_group: { code: @property_group.code, filter_by_groups: @property_group.filter_by_groups, name: @property_group.name, next_group_id: @property_group.next_group_id, sort_order: @property_group.sort_order }
    end

    assert_response 201
  end

  test "should show property_group" do
    get :show, id: @property_group
    assert_response :success
  end

  test "should update property_group" do
    put :update, id: @property_group, property_group: { code: @property_group.code, filter_by_groups: @property_group.filter_by_groups, name: @property_group.name, next_group_id: @property_group.next_group_id, sort_order: @property_group.sort_order }
    assert_response 204
  end

  test "should destroy property_group" do
    assert_difference('PropertyGroup.count', -1) do
      delete :destroy, id: @property_group
    end

    assert_response 204
  end
end
