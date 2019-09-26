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
#  address                :string
#

require 'csv'

class Web::UsersController < Web::ApplicationController
  before_action :authenticate_admin!

  def heatmap
    @heat_users = params[:last_24hours].present? || params[:last_sign_in_at].present? ? list_heat_user : []
    render template: "web/users/heatmap.html.erb"
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
end
