# == Schema Information
#
# Table name: apparel_images
#
#  id         :integer          not null, primary key
#  apparel_id :integer          not null
#  file       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ApparelImagesControllerTest < ActionController::TestCase
  setup do
    @apparel_image = apparel_images(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:apparel_images)
  end

  test "should create apparel_image" do
    assert_difference('ApparelImage.count') do
      post :create, apparel_image: { apparel_id: @apparel_image.apparel_id, image: @apparel_image.image }
    end

    assert_response 201
  end

  test "should show apparel_image" do
    get :show, id: @apparel_image
    assert_response :success
  end

  test "should update apparel_image" do
    put :update, id: @apparel_image, apparel_image: { apparel_id: @apparel_image.apparel_id, image: @apparel_image.image }
    assert_response 204
  end

  test "should destroy apparel_image" do
    assert_difference('ApparelImage.count', -1) do
      delete :destroy, id: @apparel_image
    end

    assert_response 204
  end
end
