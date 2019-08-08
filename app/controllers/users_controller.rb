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
#  agreed                 :boolean          default(FALSE), not null
#  agreed_at              :datetime
#

require 'csv'

class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:heatmap, :heat_users, :heatcount]

  def register_device
    device = Device.find_or_create_by(user: current_user, 
      provider: update_device_params[:provider], 
      uid: update_device_params[:registration_id],
      device_uid: update_device_params[:device_uid])

    if device
      Device.where(user: current_user, 
        provider: update_device_params[:provider], 
        device_uid: update_device_params[:device_uid]).
        where.not(uid: update_device_params[:registration_id]).destroy_all
    end

    render json: device
  end

  def heatmap
    @heat_users = params[:last_24hours].present? || params[:last_sign_in_at].present? ? list_heat_user : []
    render template: "users/heatmap.html.erb"
  end
  def heat_users
    render text: list_heat_user.to_map_csv.strip
  end
  def heatcount
    render text: { count: list_heat_user.count }
  end

  def list_heat_user
    filtered_users = User.where('lat >= -90 and lat <= 90').where('lng >= -180 and lng <= 180').where.not(lat: nil, lng: nil)
    filtered_users = filtered_users.where('last_sign_in_at >= ?', (Time.now - 1.day)) if params[:last_24hours].present?
    filtered_users = filtered_users.where('last_sign_in_at >= ?', params[:last_sign_in_at].to_time) if params[:last_sign_in_at].present?
    filtered_users
  end


  def unregister_device
    Device.where(user: current_user, 
        provider: update_device_params[:provider], 
        device_uid: update_device_params[:device_uid]).destroy_all
    
    head :no_content
  end

  def update_image
    current_user.update(update_image_params)
    render json: current_user
  end

  def agreed_to_terms
    current_user.agreed = true
    current_user.agreed_at = Time.new
    
    if current_user.save
      render json: current_user
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  protected

    def update_image_params
      params.permit(:image, :image_cache, :social_image)
    end

    def update_device_params
      params.permit(:registration_id, :provider, :device_uid)
    end
end
