# == Schema Information
#
# Table name: apparel_images
#
#  id         :integer          not null, primary key
#  apparel_id :integer          not null
#  file       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ApparelImagesController < ApplicationController
  before_action :set_apparel_image, only: [:show, :update, :destroy]

  # GET /apparel_images
  # GET /apparel_images.json
  def index
    @apparel_images = ApparelImage.all

    render json: @apparel_images
  end

  # GET /apparel_images/1
  # GET /apparel_images/1.json
  def show
    render json: @apparel_image
  end

  # POST /apparel_images
  # POST /apparel_images.json
  def create
    @apparel_image = ApparelImage.new(apparel_image_params)

    if @apparel_image.save
      render json: @apparel_image, status: :created, location: @apparel_image
    else
      render json: @apparel_image.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /apparel_images/1
  # PATCH/PUT /apparel_images/1.json
  def update
    @apparel_image = ApparelImage.find(params[:id])

    if @apparel_image.update(apparel_image_params)
      head :no_content
    else
      render json: @apparel_image.errors, status: :unprocessable_entity
    end
  end

  # DELETE /apparel_images/1
  # DELETE /apparel_images/1.json
  def destroy
    @apparel_image.destroy

    head :no_content
  end

  private

    def set_apparel_image
      @apparel_image = ApparelImage.find(params[:id])
    end

    def apparel_image_params
      params.require(:apparel_image).permit(:apparel_id, :image)
    end
end
