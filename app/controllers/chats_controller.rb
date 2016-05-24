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

class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat, only: [:show, :update, :destroy]

  # GET /chats
  # GET /chats.json
  def index
    @chats = Chat.all

    render json: @chats
  end

  # GET /chats/active_by_user/1
  # GET /chats/active_by_user/1.json
  def active_by_user
    @chat = Chat.active_by_user(current_user, User.find(params[:id]))
    render json: @chat
  end

  # GET /chats/1
  # GET /chats/1.json
  def show
    render json: @chat
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
    @chat = Chat.find(params[:id])

    if @chat.update(chat_params)
      head :no_content
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
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
    end

    def chat_params
      params.require(:chat).permit(:user1_id, :user2_id, :user1_accepted, :user2_accepted)
    end
end
