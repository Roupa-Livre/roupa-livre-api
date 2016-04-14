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
#

class ApparelsController < ApplicationController
  before_action :set_apparel, only: [:show, :update, :destroy, :like, :dislike]

  # GET /apparels
  # GET /apparels.json
  def index
    @apparels = Apparel.all

    render json: @apparels
  end

  # GET /apparels/search
  # GET /apparels/search.json
  def search
    @apparels = Apparel.where.not(:id => ApparelRating.where(user: current_user).select(:apparel_id))
    @apparels = @apparels.joins(:user).by_distance(:origin => current_user)

    render json: @apparels.as_json(include: { 
      :apparel_images => { only: [:file] }, 
      :apparel_tags => { only: [:name] },
      :user => { only: [ :nickname ] }
    })
  end

  def dislike
    rate(false)
  end

  def like
    rate(true)
  end

  def rate(liked)
    apparel_rating = ApparelRating.find_or_create_by(user: current_user, apparel: @apparel) do |apparel_rating|
      apparel_rating.liked = liked
    end
    apparel_rating.liked = liked
    apparel_rating.save

    search
  end

  # GET /apparels/1
  # GET /apparels/1.json
  def show
    render json: @apparel
  end

  # POST /apparels
  # POST /apparels.json
  def create
    @apparel = Apparel.new(apparel_params)

    if @apparel.save
      render json: @apparel, status: :created, location: @apparel
    else
      render json: @apparel.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /apparels/1
  # PATCH/PUT /apparels/1.json
  def update
    @apparel = Apparel.find(params[:id])

    if @apparel.update(apparel_params)
      head :no_content
    else
      render json: @apparel.errors, status: :unprocessable_entity
    end
  end

  # DELETE /apparels/1
  # DELETE /apparels/1.json
  def destroy
    @apparel.destroy

    head :no_content
  end

  private

    def set_apparel
      @apparel = Apparel.find(params[:id])
    end

    def apparel_params
      params.require(:apparel).permit(:user_id, :title, :description, :size_info, :gender, :age_info)
    end
end
