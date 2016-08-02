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
  before_action :authenticate_user!
  before_action :set_apparel, only: [:show, :update, :destroy, :like, :dislike]
  before_action :check_apparel_owner, only: [:show, :update, :destroy]

  # GET /apparels
  # GET /apparels.json
  def index
    @apparels = Apparel.where.not(user: current_user)
    @apparels = @apparels.where.not(:id => ApparelRating.where(user: current_user).select(:apparel_id))

    @apparels = @apparels.where(gender: params[:gender]) if params[:gender].present?
    @apparels = @apparels.where(age_info: params[:age_info]) if params[:age_info].present?
    @apparels = @apparels.where(size_info: params[:size_info]) if params[:size_info].present?

    @apparels = @apparels.joins(:user).by_distance(:origin => current_user)

    render json: @apparels
  end

  # GET /apparels/owned
  # GET /apparels/owned.json
  def owned
    @apparels = Apparel.where(user: current_user)

    render json: @apparels
  end

  # GET /apparels/1
  # GET /apparels/1.json
  def show
    render json: @apparel
  end

  # POST /apparels
  # POST /apparels.json
  def create
    load_new_apparel_images(apparel_params) do |final_params|
      @apparel = Apparel.new(final_params)
      @apparel.user = current_user
      if @apparel.save
        render json: @apparel, status: :created, location: @apparel
      else
        render json: @apparel.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /apparels/1
  # PATCH/PUT /apparels/1.json
  def update
    @apparel = Apparel.find(params[:id])

    load_new_apparel_images(apparel_params) do |final_params|
      if @apparel.update(final_params)
        head :no_content
      else
        render json: @apparel.errors, status: :unprocessable_entity
      end
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

    def check_apparel_owner
      if @apparel.user != current_user
        render :nothing => true, status: :unauthorized
        false
      end
    end

    def apparel_params
      params.require(:apparel).permit(:title, :description, :size_info, :gender, :age_info, 
        apparel_tags_attributes: [:id, :name, :_destroy], 
        apparel_images_attributes: [:id, :data, :file, :file_cache, :_destroy])
    end
end
