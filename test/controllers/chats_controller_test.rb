# == Schema Information
#
# Table name: chats
#
#  id              :integer          not null, primary key
#  user_1_id       :integer          not null
#  user_2_id       :integer          not null
#  user_1_accepted :boolean
#  user_2_accepted :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  closed          :boolean
#  closed_at       :datetime
#

require 'test_helper'

class ChatsControllerTest < ActionController::TestCase
  setup do
    @chat = chats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:chats)
  end

  test "should create chat" do
    assert_difference('Chat.count') do
      post :create, chat: { user1_accepted: @chat.user1_accepted, user1_id: @chat.user1_id, user2_accepted: @chat.user2_accepted, user2_id: @chat.user2_id }
    end

    assert_response 201
  end

  test "should show chat" do
    get :show, id: @chat
    assert_response :success
  end

  test "should update chat" do
    put :update, id: @chat, chat: { user1_accepted: @chat.user1_accepted, user1_id: @chat.user1_id, user2_accepted: @chat.user2_accepted, user2_id: @chat.user2_id }
    assert_response 204
  end

  test "should destroy chat" do
    assert_difference('Chat.count', -1) do
      delete :destroy, id: @chat
    end

    assert_response 204
  end
end
