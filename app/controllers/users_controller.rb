# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  provider               :string           default("email"), not null
#  uid                    :string           not null
#  type                   :string           not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  name                   :string
#  email                  :string
#  nickname               :string
#  social_image           :string
#  image                  :string
#  phone                  :string
#  tokens                 :json
#  created_at             :datetime
#  updated_at             :datetime
#  lat                    :float
#  lng                    :float
#

class UsersController < ApplicationController
  before_action :authenticate_user!

  def register_device
    device = Device.find_or_create_by(user: current_user, provider: update_image_params[:provider], uid: update_image_params[:registration_id])
    render json: device
  end

  def unregister_device
    device = Device.find_by(user: current_user, provider: update_image_params[:provider], uid: update_image_params[:registration_id])
    device.destroy if device
    head :no_content
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
