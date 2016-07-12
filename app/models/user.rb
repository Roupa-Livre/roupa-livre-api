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

require 'file_size_validator'

class User < ActiveRecord::Base
  include DeviseTokenAuth::Concerns::User
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable,
          :confirmable, :omniauthable
  
  acts_as_mappable

  has_many :identities, dependent: :destroy

  after_save :publish_token_change

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
      if names_separator_index > -1
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

  def publish_token_change
    if tokens_changed?
      current_tokens = self.tokens
      if current_tokens.length > 0
        latest_token = self.tokens.max_by { |cid, v| v[:expiry] || v["expiry"] }
        if latest_token
          data = { type: 'refresh_token', token: latest_token, user: self.id }.to_json
          REDIS.publish 'refresh_token', data
        end
      end
    end
    result
  end
end
