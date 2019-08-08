# == Schema Information
#
# Table name: chats
#
#  id                  :integer          not null, primary key
#  user_1_id           :integer          not null
#  user_2_id           :integer          not null
#  user_1_accepted     :boolean
#  user_2_accepted     :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  closed              :boolean
#  closed_at           :datetime
#  user_1_last_read_at :datetime
#  user_2_last_read_at :datetime
#

class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat, only: [:show, :update, :destroy, :block]

  # GET /chats
  # GET /chats.json
  def index
    @chats = Chat.where('user_1_id = ? or user_2_id = ?', current_user.id, current_user.id)

    blocked_user_ids = current_user.blocked_users.select(:blocked_user_id)
    @chats = @chats.where.not(:user_1_id => blocked_user_ids)
    @chats = @chats.where.not(:user_2_id => blocked_user_ids)

    render json: @chats
  end

  # GET /chats/active_by_user/1
  # GET /chats/active_by_user/1.json
  def active_by_user
    @chat = Chat.active_by_user(current_user, User.find(params[:user_id]))
    if @chat
      return show
    else
      render status: :not_found
    end
  end

  # GET /chats/1
  # GET /chats/1.json
  def show
    if params[:include_messages].present? && to_boolean(params[:include_messages])
      chat.mark_as_read(current_user)
      render json: @chat, include_messages: true
    else
      render json: @chat
    end
  end

  # POST /chats
  # POST /chats.json
  def create
    @chat = Chat.new(chat_params)

    if @chat.save
      render json: @chat, status: :created, location: @chat
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /chats/1
  # PATCH/PUT /chats/1.json
  def update
    if @chat.update(chat_params)
      head :no_content
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  # POST /chats/1/block
  # POST /chats/1/block.json
  def block
    blocked_user_id = nil
    if @chat.user_1 == current_user
      blocked_user_id = @chat.user_2_id
    elsif @chat.user_2 == current_user
      blocked_user_id = @chat.user_1_id
    end

    blocked_user = current_user.blocked_users.new(blocked_user_id: blocked_user_id)
    if blocked_user_id && blocked_user.save
      head :no_content
    else
      render json: blocked_user.errors, status: :unprocessable_entity
    end

    head :no_content
  end

  # DELETE /chats/1
  # DELETE /chats/1.json
  def destroy
    @chat.destroy

    head :no_content
  end

  private

    def set_chat
      @chat = Chat.find(params[:id])
      if current_user != @chat.user_1  && @chat.user_2 != current_user
        render :nothing => true, status: :unauthorized
        false
      end
    end

    def chat_params
      params.require(:chat).permit(:user1_id, :user2_id, :user1_accepted, :user2_accepted)
    end
end
