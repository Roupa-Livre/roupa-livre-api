class Web::CustomNotificationsController < Web::ApplicationController
  before_action :set_custom_notification, only: [:send_notification, :show]

  # GET /custom_notifications
  # GET /custom_notifications.json
  def index
    @custom_notifications = CustomNotification.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @custom_notifications }
    end
  end

  # GET /custom_notifications/1
  # GET /custom_notifications/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @custom_notifications }
    end
  end

  # GET /custom_notifications/new
  # GET /custom_notifications/new.json
  def new
    @custom_notification = CustomNotification.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @custom_notification }
    end
  end

  # POST /custom_notifications
  # POST /custom_notifications.json
  def create
    @custom_notification = CustomNotification.new(custom_notification_params)

    respond_to do |format|
      if @custom_notification.save
        format.html { redirect_to web_custom_notifications_path, notice: 'Noticação criada.' }
        format.json { render json: @custom_notification, status: :created, location: web_custom_notifications_path }
      else
        format.html { render action: "new" }
        format.json { render json: @custom_notification.errors, status: :unprocessable_entity }
      end
    end
  end

  def send_notification
    respond_to do |format|
      if @custom_notification.send_notification
        format.html { redirect_to web_custom_notifications_path, notice: 'Noticação enviada.' }
        format.json { render json: @custom_notification, status: :created, location: web_custom_notifications_path }
      else
        format.html { render action: "show" }
        format.json { render json: @custom_notification.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_custom_notification
      @custom_notification = CustomNotification.find(params[:id])
    end

    def custom_notification_params
      params.require(:custom_notification).permit(:push_title, :push_message, :title, :image_url, :action_title, :action_link, :body)
    end
end
