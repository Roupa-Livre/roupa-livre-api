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

class ChatMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat_message, only: [:show, :update, :destroy]
  before_action :set_new_chat_message, only: [:create]
  before_action :check_chat_ownership, only: [:show, :update, :destroy, :create]
  before_action :check_chat_message_ownership, only: [:create]

  # GET /chat_messages
  # GET /chat_messages.json
  def index
    # sleep(3) para testes

    @chat_messages = []
    if params[:chat_id].present?
      chat = Chat.find(params[:chat_id])
      if chat && chat.is_owner(current_user)
        if params[:last_read_at].present?
          @chat_messages = chat.get_last_messages(params[:last_read_at].to_time)
        elsif params[:base_message_id].present?
          @chat_messages = chat.previous_messages(params[:base_message_id].to_i, params[:page_size].to_i)
        else
          @chat_messages = chat.get_last_messages(nil, nil, params[:page_size].to_i)
        end
        chat.mark_as_read(current_user)
      end
    end

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
    if @chat_message.save
      render json: @chat_message, status: :created, location: @chat_message
    else
      render json: @chat_message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /chat_messages/1
  # PATCH/PUT /chat_messages/1.json
  def update
    # @chat_message = ChatMessage.find(params[:id])

    # if @chat_message.update(chat_message_params)
    #   head :no_content
    # else
    #   render json: @chat_message.errors, status: :unprocessable_entity
    # end
    render :nothing => true, status: :unauthorized
  end

  # DELETE /chat_messages/1
  # DELETE /chat_messages/1.json
  def destroy
    # @chat_message.destroy
    # head :no_content

    render :nothing => true, status: :unauthorized
  end

  private

    def set_new_chat_message
      @chat_message = ChatMessage.new(chat_message_params)
      @chat_message.user = current_user
      @chat = @chat_message.chat
    end

    def set_chat_message
      @chat_message = ChatMessage.find(params[:id])
      @chat = @chat_message.chat
    end

    def check_chat_ownership
      chat = @chat_message.chat
      if !@chat_message.chat.is_owner(current_user)
        render :nothing => true, status: :unauthorized
      end
    end

    def check_chat_message_ownership
      if !@chat_message.is_owner(current_user)
        render :nothing => true, status: :unauthorized
      end
    end

    def chat_message_params
      params.require(:chat_message).permit(:chat_id, :user_id, :message)
    end
end
