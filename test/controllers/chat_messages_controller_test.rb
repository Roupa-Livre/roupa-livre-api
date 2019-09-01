# == Schema Information
#
# Table name: chat_messages
#
#  id         :integer          not null, primary key
#  chat_id    :integer          not null
#  user_id    :integer
#  message    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string           default("ChatMessage")
#

require 'test_helper'

class ChatMessagesControllerTest < ActionController::TestCase
  setup do
    @chat_message = chat_messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:chat_messages)
  end

  test "should create chat_message" do
    assert_difference('ChatMessage.count') do
      post :create, chat_message: { chat_id: @chat_message.chat_id, message: @chat_message.message, user_id: @chat_message.user_id }
    end

    assert_response 201
  end

  test "should show chat_message" do
    get :show, id: @chat_message
    assert_response :success
  end

  test "should update chat_message" do
    put :update, id: @chat_message, chat_message: { chat_id: @chat_message.chat_id, message: @chat_message.message, user_id: @chat_message.user_id }
    assert_response 204
  end

  test "should destroy chat_message" do
    assert_difference('ChatMessage.count', -1) do
      delete :destroy, id: @chat_message
    end

    assert_response 204
  end
end
