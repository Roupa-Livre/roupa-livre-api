# == Schema Information
#
# Table name: apparel_tags
#
#  id         :integer          not null, primary key
#  apparel_id :integer          not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#

require 'test_helper'

class ApparelTagsControllerTest < ActionController::TestCase
  setup do
    @apparel_tag = apparel_tags(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:apparel_tags)
  end

  test "should create apparel_tag" do
    assert_difference('ApparelTag.count') do
      post :create, apparel_tag: { apparel_id: @apparel_tag.apparel_id, name: @apparel_tag.name }
    end

    assert_response 201
  end

  test "should show apparel_tag" do
    get :show, id: @apparel_tag
    assert_response :success
  end

  test "should update apparel_tag" do
    put :update, id: @apparel_tag, apparel_tag: { apparel_id: @apparel_tag.apparel_id, name: @apparel_tag.name }
    assert_response 204
  end

  test "should destroy apparel_tag" do
    assert_difference('ApparelTag.count', -1) do
      delete :destroy, id: @apparel_tag
    end

    assert_response 204
  end
end
