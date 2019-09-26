# == Schema Information
#
# Table name: apparel_tags
#
#  id            :integer          not null, primary key
#  apparel_id    :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  deleted_at    :datetime
#  global_tag_id :integer          not null
#

class ApparelTagsController < APIController
  before_action :set_apparel_tag, only: [:show, :update, :destroy]

  # GET /apparel_tags
  # GET /apparel_tags.json
  def index
    @apparel_tags = ApparelTag.all

    render json: @apparel_tags
  end

  # GET /apparel_tags/1
  # GET /apparel_tags/1.json
  def show
    render json: @apparel_tag
  end

  # POST /apparel_tags
  # POST /apparel_tags.json
  def create
    @apparel_tag = ApparelTag.new(apparel_tag_params)

    if @apparel_tag.save
      render json: @apparel_tag, status: :created, location: @apparel_tag
    else
      render json: @apparel_tag.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /apparel_tags/1
  # PATCH/PUT /apparel_tags/1.json
  def update
    @apparel_tag = ApparelTag.find(params[:id])

    if @apparel_tag.update(apparel_tag_params)
      head :no_content
    else
      render json: @apparel_tag.errors, status: :unprocessable_entity
    end
  end

  # DELETE /apparel_tags/1
  # DELETE /apparel_tags/1.json
  def destroy
    @apparel_tag.destroy

    head :no_content
  end

  private

    def set_apparel_tag
      @apparel_tag = ApparelTag.find(params[:id])
    end

    def apparel_tag_params
      params.require(:apparel_tag).permit(:apparel_id, :name)
    end
end
