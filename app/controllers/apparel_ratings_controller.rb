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

class ApparelRatingsController < ApplicationController
  before_action :set_apparel_rating, only: [:show, :update, :destroy]

  # GET /apparel_ratings
  # GET /apparel_ratings.json
  def index
    @apparel_ratings = ApparelRating.all

    render json: @apparel_ratings
  end

  # GET /apparel_ratings/1
  # GET /apparel_ratings/1.json
  def show
    render json: @apparel_rating
  end

  # POST /apparel_ratings
  # POST /apparel_ratings.json
  def create
    @apparel_rating = ApparelRating.new(apparel_rating_params)
    @apparel_rating.user = current_user

    if @apparel_rating.save
      chat = check_apparel_rating

      render json: @apparel_rating, chat: chat, status: :created, location: @apparel_rating
    else
      render json: @apparel_rating.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /apparel_ratings/1
  # PATCH/PUT /apparel_ratings/1.json
  def update
    @apparel_rating = ApparelRating.find(params[:id])
    if @apparel_rating.user != current_user
      render status: :unauthorized
    elsif @apparel_rating.update(apparel_rating_params)
      chat = check_apparel_rating
      
      render json: @apparel_rating, chat: chat
    else
      render json: @apparel_rating.errors, status: :unprocessable_entity
    end
  end

  # DELETE /apparel_ratings/1
  # DELETE /apparel_ratings/1.json
  def destroy
    @apparel_rating.destroy

    head :no_content
  end

  private

    def check_apparel_rating
      chat = nil
      if @apparel_rating.liked 
        owner_user = @apparel_rating.user
        liked_user = @apparel_rating.apparel.user

        liked_user_reverse_liked_ratings = liked_user.apparel_ratings.where(apparel: owner_user.apparels, liked: true)
        if liked_user_reverse_liked_ratings.length > 0
          chat = Chat.find_or_create_chat(owner_user, liked_user)
        end
      end
      chat
    end

    def set_apparel_rating
      @apparel_rating = ApparelRating.find(params[:id])
    end

    def apparel_rating_params
      params.require(:apparel_rating).permit(:apparel_id, :user_id, :liked)
    end
end
