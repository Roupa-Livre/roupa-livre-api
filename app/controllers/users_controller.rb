class UsersController < ApplicationController
  before_action :authenticate_user!

  def register_device
    identity = Identity.find_or_create_by(user: current_user, provider: update_image_params[:provider], uid: update_image_params[:registration_id])
    render json: identity
  end

  def update_image
    current_user.update(update_image_params)
    render json: current_user
  end

  protected

    def update_image_params
      params.permit(:image, :image_cache)
    end

    def update_image_params
      params.permit(:registration_id, :provider)
    end
end
