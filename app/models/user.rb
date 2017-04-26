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
#

require 'file_size_validator'
require 'csv'

class User < ActiveRecord::Base
  include DeviseTokenAuth::Concerns::User
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable,
          :confirmable, :omniauthable
  
  acts_as_mappable

  has_many :identities, dependent: :destroy
  has_many :blocked_users, dependent: :destroy

  def km_from_user(other_user)
    self.distance_from(other_user, :units => :kms) if other_user.lat && other_user.lng
  end

  def masked_email
    if email && email.length > 5
      email[0..4] + ("*" * (email.length - 5))
    else
      nil
    end
  end

  def first_name
    if name && name.length > 1 # pelo menos 2 letras
      names_separator_index = name.index(' ')
      if names_separator_index && names_separator_index > -1
        if names_separator_index > 1 # pelo menos 2 letras
          name[0..(names_separator_index-1)]
        else
          nil
        end
      else
        name
      end
    else
      nil
    end
  end

  def public_name
    nickname || first_name || masked_email
  end

  def build_auth_header(token, client_id='default')
    result = super(token, client_id)

    data = { type: 'refresh_token', token: token, client_id: client_id, user: self.id }.to_json
    REDIS.publish 'refresh_token', data

    return result
  end

  def chats_count
    Chat.where('user_1_id = ? or user_2_id = ?', self.id, self.id).count
  end

  def apparels_count
    self.apparels.count
  end

  def self.to_map_csv
    custom_column_names = ["lat", "lng", "public_name"]
    CSV.generate do |csv|
      csv << custom_column_names
      all.each do |user|
        csv << [user.lat, user.lng, user.public_name]
      end
    end
  end

  def self.to_csv
    custom_column_names = ["name", "email", "public_name", "nickname", "social_image", "phone", "peças", "chats"]
    CSV.generate do |csv|
      csv << custom_column_names
      all.each do |user|
        csv << [user.name, user.email, user.public_name, user.nickname, user.social_image ? user.social_image : "", user.phone ? user.phone : "", user.apparels_count, user.chats_count]
      end
    end
  end
end
