# == Schema Information
#
# Table name: apparels
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  title       :string           not null
#  description :text
#  size_info   :string
#  gender      :string
#  age_info    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  deleted_at  :datetime
#

require 'test_helper'

class ApparelsControllerTest < ActionController::TestCase
  setup do
    @apparel = apparels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:apparels)
  end

  test "should create apparel" do
    assert_difference('Apparel.count') do
      post :create, apparel: { age_info: @apparel.age_info, description: @apparel.description, gender: @apparel.gender, itle: @apparel.itle, size_info: @apparel.size_info, t: @apparel.t, user_id: @apparel.user_id }
    end

    assert_response 201
  end

  test "should show apparel" do
    get :show, id: @apparel
    assert_response :success
  end

  test "should update apparel" do
    put :update, id: @apparel, apparel: { age_info: @apparel.age_info, description: @apparel.description, gender: @apparel.gender, itle: @apparel.itle, size_info: @apparel.size_info, t: @apparel.t, user_id: @apparel.user_id }
    assert_response 204
  end

  test "should destroy apparel" do
    assert_difference('Apparel.count', -1) do
      delete :destroy, id: @apparel
    end

    assert_response 204
  end
end
