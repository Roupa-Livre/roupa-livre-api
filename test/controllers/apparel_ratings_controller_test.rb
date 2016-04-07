# == Schema Information
#
# Table name: apparel_ratings
#
#  id         :integer          not null, primary key
#  apparel_id :integer          not null
#  user_id    :integer          not null
#  liked      :boolean          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class ApparelRatingsControllerTest < ActionController::TestCase
  setup do
    @apparel_rating = apparel_ratings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:apparel_ratings)
  end

  test "should create apparel_rating" do
    assert_difference('ApparelRating.count') do
      post :create, apparel_rating: { apparel_id: @apparel_rating.apparel_id, liked: @apparel_rating.liked, user_id: @apparel_rating.user_id }
    end

    assert_response 201
  end

  test "should show apparel_rating" do
    get :show, id: @apparel_rating
    assert_response :success
  end

  test "should update apparel_rating" do
    put :update, id: @apparel_rating, apparel_rating: { apparel_id: @apparel_rating.apparel_id, liked: @apparel_rating.liked, user_id: @apparel_rating.user_id }
    assert_response 204
  end

  test "should destroy apparel_rating" do
    assert_difference('ApparelRating.count', -1) do
      delete :destroy, id: @apparel_rating
    end

    assert_response 204
  end
end
