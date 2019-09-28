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

class ApparelsController < APIController
  before_action :authenticate_user!, except: [:remove_reported, :apparels_by_user, :apparels_by_tag]
  # before_action :apparels_by_user, only: [:show]
  before_action :set_apparel, only: [:show, :update, :destroy, :like, :dislike, :report, :remove_reported]
  before_action :check_apparel_owner, only: [:show, :update, :destroy]

  # GET /apparels
  # GET /apparels.json
  def index
    # sleep(20) # para testes
    @apparels = Apparel.where.not(user: current_user)
    @apparels = @apparels.where.not(:id => ApparelReport.where(user: current_user).select(:apparel_id))
    @apparels =  @apparels.where.not(:user_id => current_user.blocked_users.select(:blocked_user_id))
    @apparels = @apparels.where.not(id: params[:ignore].split(',')) if params[:ignore].present? && !params[:ignore].blank?

    if params[:apparel_property].present?
      apparel_property = JSON.parse(params[:apparel_property])
      apparel_properties = ApparelProperty.all
      properties_count = 0
      if apparel_property["category_id"].present?
        apparel_properties = apparel_properties.where('apparel_properties.category_id = ?', apparel_property["category_id"]) 
        properties_count = properties_count + 1
      end
      if apparel_property["kind_id"].present?
        apparel_properties = apparel_properties.where('apparel_properties.kind_id = ?', apparel_property["kind_id"])
        properties_count = properties_count + 1
      end
      if apparel_property["size_group_id"].present?
        apparel_properties = apparel_properties.where('apparel_properties.size_group_id = ?', apparel_property["size_group_id"])
        properties_count = properties_count + 1
      end
      if apparel_property["size_id"].present?
        apparel_properties = apparel_properties.where('apparel_properties.size_id = ?', apparel_property["size_id"])
        properties_count = properties_count + 1
      end
      if apparel_property["model_id"].present?
        apparel_properties = apparel_properties.where('apparel_properties.model_id = ?', apparel_property["model_id"])
        properties_count = properties_count + 1
      end
      if apparel_property["pattern_id"].present?
        apparel_properties = apparel_properties.where('apparel_properties.pattern_id = ?', apparel_property["pattern_id"])
        properties_count = properties_count + 1
      end
      if apparel_property["color_id"].present?
        apparel_properties = apparel_properties.where('apparel_properties.color_id = ?', apparel_property["color_id"])
        properties_count = properties_count + 1
      end
      if properties_count > 0
        properties_query = apparel_properties.group(:apparel_id).having('COUNT(distinct id) = ?', properties_count).select('apparel_id')
        # puts "IDs: " + apparel_properties.select(:apparel_id).distinct.to_json
        @apparels = @apparels.where(id: properties_query)
      end
    end

    if params[:apparel_tags].present?
      apparel_tag_names = params[:apparel_tags].split(',')
      apparel_tag_names.each do |tag_name|
        @apparels = @apparels.where(id: ApparelTag.joins(:global_tag).where('apparel_tags.apparel_id = apparels.id').where('global_tags.name = ?', tag_name).select('apparel_tags.apparel_id'))
      end
    end

    @apparels = @apparels.joins(:user)
    if current_user.has_geo?
      @apparels = @apparels.where('users.lat is not null and users.lng is not null')
    end

    apparel_range = params[:range].to_i if params[:range].present?
    if apparel_range && apparel_range > 0 && apparel_range < 100
      @apparels = @apparels.within(apparel_range, units: :kms, origin: @current_user)
      @apparels = @apparels.order('distance ASC')
    else
      @apparels = @apparels.by_distance(:origin => current_user)
    end

    if params[:show_only_liked].present? && to_boolean(params[:show_only_liked])
      @apparels = @apparels.where(user_id: Apparel.joins(:apparel_ratings).where(:apparel_ratings => { liked: true, user_id: current_user.id }).select(:user_id).distinct)
    end

    if params[:show_only_likers].present? && to_boolean(params[:show_only_likers])
      @apparels = @apparels.where(user_id: ApparelRating.joins(:apparel).where(liked: true).where(:apparels => { user_id: current_user.id }).select(:user_id).distinct)
    end

    show_liked_again = params[:show_liked_again].present? && to_boolean(params[:show_liked_again])
    show_not_liked_again = params[:show_not_liked_again].present? && to_boolean(params[:show_not_liked_again])
    if show_liked_again != show_not_liked_again
      if show_liked_again
        @apparels = @apparels.where(:id => ApparelRating.where(user: current_user, liked: true).select(:apparel_id))
      else
        @apparels = @apparels.where(:id => ApparelRating.where(user: current_user, liked: false).select(:apparel_id))
      end
    elsif !show_liked_again && !show_not_liked_again
      # caso nao tenha filtros deve esconder os apparels que ja foram rated por padrao
      @apparels = @apparels.where.not(:id => ApparelRating.where(user: current_user).select(:apparel_id))
    end

    if params[:already_seen_ids].present?
      already_seen_ids = params[:already_seen_ids].split(',').map { |id_str| id_str.to_i }
      @apparels = @apparels.where.not(id: already_seen_ids)
    end

    @apparels = @apparels.joins(:apparel_images).uniq
    @apparels = @apparels.limit(params[:page_size] || 10)

    render json: @apparels, each_serializer: ApparelReadonlySerializer
  end

  # GET /apparels/owned
  # GET /apparels/owned.json
  def owned
    @apparels = Apparel.where(user: current_user)

    render json: @apparels
  end

  def matched
    @apparels = Apparel.joins(:chat_apparels).joins(:chat_apparels => :chat)
      .where.not('apparels.user_id = ? ', current_user.id)
      .where('user_1_id = ? or user_2_id = ?', current_user.id, current_user.id)
      .order('chat_apparels.created_at desc')

    if params[:term].present? && !params[:term].blank?
      term = "%#{params[:term].gsub("\'", "\\\'").downcase}%"
      san_term = Apparel.sanitize(term)

      @apparels = @apparels.joins("left join chat_messages on chat_messages.chat_id = chats.id")
        .joins("left join users on users.id != #{current_user.id} 
          and (users.id = chats.user_1_id or users.id = chats.user_2_id)")
        .where("unaccent(lower(chat_messages.message)) like #{san_term} 
          or unaccent(lower(apparels.title)) like #{san_term}
          or unaccent(lower(apparels.description)) like #{san_term}
          or unaccent(lower(users.name)) like #{san_term}")

      group_by = Apparel.column_names.map{|col| "apparels.#{col}"}
      group_by.push('chat_apparels.created_at')
      @apparels = @apparels.group(group_by);
    end

    render json: @apparels, each_serializer: ApparelReadonlySerializer
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
      # puts final_params[:apparel_property].to_json
      # logger.debug final_params[:apparel_property_attributes].to_json
      # puts final_params[:apparel][:apparel_property].to_json
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

  def apparels_by_user
    @apparels = Apparel.where(user_id: params[:user_id])

    render json: @apparels
  end

  def apparels_by_tag
    @apparels = Apparel.joins(:apparel_tags).joins(apparel_tags: :global_tag)
      .where('global_tags.id = ?', params[:tag_id])
      .where('apparels.user_id <> ?', current_user.id)

    render json: @apparels
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
        apparel_property_attributes: [:id, :category_id, :kind_id, :model_id, :size_group_id,
:size_id, :pattern_id, :color_id, :_destroy],
        apparel_tags_attributes: [:id, :name, :_destroy],
        apparel_images_attributes: [:id, :data, :file, :file_cache, :_destroy])
    end

    def report_params
      params.require(:apparel).permit(:reason)
    end

end
