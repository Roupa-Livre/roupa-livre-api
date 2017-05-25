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
#  deleted_at  :datetime
#

class ApparelsController < ApplicationController
  before_action :authenticate_user!, except: [:remove_reported]
  before_action :set_apparel, only: [:show, :update, :destroy, :like, :dislike, :report, :remove_reported]
  before_action :check_apparel_owner, only: [:show, :update, :destroy]

  # GET /apparels
  # GET /apparels.json
  def index
    # sleep(3) para testes

    @apparels = Apparel.where.not(user: current_user)
    @apparels = @apparels.where.not(:id => ApparelRating.where(user: current_user).select(:apparel_id))
    @apparels = @apparels.where.not(:id => ApparelReport.where(user: current_user).select(:apparel_id))
    @apparels =  @apparels.where.not(:user_id => current_user.blocked_users.select(:blocked_user_id))
    @apparels = @apparels.where.not(id: params[:ignore].split(',')) if params[:ignore].present? && !params[:ignore].blank?

    @apparels = @apparels.where(gender: params[:gender]) if params[:gender].present?
    @apparels = @apparels.where(age_info: params[:age_info]) if params[:age_info].present?
    @apparels = @apparels.where(size_info: params[:size_info]) if params[:size_info].present?
    if params[:apparel_tags].present?
      apparel_tag_names = params[:apparel_tags].split(',')
      apparel_tag_names.each do |tag_name|
        @apparels = @apparels.where(id: ApparelTag.where('apparel_tags.apparel_id = apparels.id').where('apparel_tags.name = ?', tag_name).select('apparel_tags.apparel_id'))  
      end
    end

    @apparels = @apparels.joins(:user)
    if current_user.has_geo?
      @apparels = @apparels.where('users.lat is not null and users.lng is not null')
    end
    if params[:range].present?
      apparel_range = params[:range].to_i
      if apparel_range > 0 && apparel_range < 100
        @apparels = @apparels.within(apparel_range, units: :kms, origin: @current_user)
      end
    end

    @apparels = @apparels.by_distance(:origin => current_user)
    @apparels = @apparels.joins(:apparel_images).uniq

    @apparels = @apparels.limit(params[:page_size] || 10)

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

  # POST /apparels/1/report
  # POST /apparels/1/report.json
  def report
    @apparel.report(current_user, report_params[:reason]) if current_user

    head :no_content
  end

  # GET /apparels/1/remove_reported
  # GET /apparels/1/remove_reported.json
  def remove_reported
    if @apparel.apparel_reports.where(number: params[:token]).count > 0
      @apparel.destroy
      head :no_content
    else
      render :nothing => true, status: :unauthorized
    end
  end

  # DELETE /apparels/1
  # DELETE /apparels/1.json
  def destroy
    @apparel.really_destroy!

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

    def report_params
      params.require(:apparel).permit(:reason)
    end
end
