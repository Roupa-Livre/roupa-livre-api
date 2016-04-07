# == Schema Information
#
# Table name: chat_messages
#
#  id         :integer          not null, primary key
#  chat_id    :integer          not null
#  user_id    :integer          not null
#  message    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ChatMessagesController < ApplicationController
  before_action :set_chat_message, only: [:show, :update, :destroy]

  # GET /chat_messages
  # GET /chat_messages.json
  def index
    @chat_messages = ChatMessage.all

    render json: @chat_messages
  end

  # GET /chat_messages/1
  # GET /chat_messages/1.json
  def show
    render json: @chat_message
  end

  # POST /chat_messages
  # POST /chat_messages.json
  def create
    @chat_message = ChatMessage.new(chat_message_params)

    if @chat_message.save
      render json: @chat_message, status: :created, location: @chat_message
    else
      render json: @chat_message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /chat_messages/1
  # PATCH/PUT /chat_messages/1.json
  def update
    @chat_message = ChatMessage.find(params[:id])

    if @chat_message.update(chat_message_params)
      head :no_content
    else
      render json: @chat_message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /chat_messages/1
  # DELETE /chat_messages/1.json
  def destroy
    @chat_message.destroy

    head :no_content
  end

  private

    def set_chat_message
      @chat_message = ChatMessage.find(params[:id])
    end

    def chat_message_params
      params.require(:chat_message).permit(:chat_id, :user_id, :message)
    end
end
