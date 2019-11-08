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

require 'file_size_validator'
require 'csv'

class User < ActiveRecord::Base
  include DeviseTokenAuth::Concerns::User
  include ModelWithFile

  before_save :skip_confirmation!

  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable,
          :confirmable, :omniauthable

  acts_as_mappable

  has_many :identities, dependent: :destroy
  has_many :blocked_users, dependent: :destroy

  has_many :apparels, :foreign_key => "user_id", dependent: :destroy
  accepts_nested_attributes_for :apparels, :allow_destroy => true

  has_many :apparel_ratings, :foreign_key => "user_id", dependent: :destroy
  accepts_nested_attributes_for :apparel_ratings, :allow_destroy => true

  mount_uploader :image, UserImageUploader
  validates :image, allow_blank: true, file_size: { maximum: 3.megabytes.to_i,  message: "O arquivo enviado é muito grande. Tamanho máximo 3 MB."}

  def km_from_user(other_user)
    self.distance_from(other_user, :units => :kms) if other_user.has_geo?
  end

  def has_geo?
    self.lat && self.lng
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

  def self.destroy_user_and_dependecies(user_id)
    ChatMessage.destroy_all(user_id: user_id)
    ChatApparel.with_deleted.where(chat: Chat.where(user_1_id: user_id)).each { |i| i.really_destroy! }
    ChatApparel.with_deleted.where(chat: Chat.where(user_2_id: user_id)).each { |i| i.really_destroy! }
    Chat.destroy_all(user_1_id: user_id)
    Chat.destroy_all(user_2_id: user_id)

    ApparelImage.with_deleted.where(apparel: Apparel.with_deleted.where(user_id: user_id)).each { |i| i.really_destroy! }
    ApparelProperty.with_deleted.where(apparel: Apparel.with_deleted.where(user_id: user_id)).each { |i| i.really_destroy! }
    ApparelRating.with_deleted.where(apparel: Apparel.with_deleted.where(user_id: user_id)).each { |i| i.really_destroy! }
    ApparelReport.with_deleted.where(apparel: Apparel.with_deleted.where(user_id: user_id)).each { |i| i.really_destroy! }
    ApparelTag.with_deleted.where(apparel: Apparel.with_deleted.where(user_id: user_id)).each { |i| i.really_destroy! }
    Apparel.with_deleted.where(user_id: user_id).each { |i| i.really_destroy! }

    ApparelRating.with_deleted.where(user_id: user_id).each { |i| i.really_destroy! }
    ApparelReport.with_deleted.where(user_id: user_id).each { |i| i.really_destroy! }

    Device.destroy_all(user_id: user_id)
    Identity.destroy_all(user_id: user_id)
    BlockedUser.destroy_all(user_id: user_id)
    BlockedUser.destroy_all(blocked_user_id: user_id)

    User.find(user_id).destroy
  end

  # def twitter
  #   identities.where( :provider => "twitter" ).first
  # end

  # def twitter_client
  #   @twitter_client ||= Twitter.client( access_token: twitter.accesstoken )
  # end

  def facebook
    identities.where( :provider => "facebook" ).first
  end

  def facebook_client
    @facebook_client ||= Facebook.client( access_token: facebook.accesstoken )
  end

  # def instagram
  #   identities.where( :provider => "instagram" ).first
  # end

  # def instagram_client
  #   @instagram_client ||= Instagram.client( access_token: instagram.accesstoken )
  # end

  # def google_oauth2
  #   identities.where( :provider => "google_oauth2" ).first
  # end

  # def google_oauth2_client
  #   if !@google_oauth2_client
  #     @google_oauth2_client = Google::APIClient.new(:application_name => 'HappySeed App', :application_version => "1.0.0" )
  #     @google_oauth2_client.authorization.update_token!({:access_token => google_oauth2.accesstoken, :refresh_token => google_oauth2.refreshtoken})
  #   end
  #   @google_oauth2_client
  # end

  def register(params, user_type)
    params = params.merge(type: user_type, uid: params[:uid].present? ? params[:uid] : nil)
    self.update_attributes(params)
  end

  def merge_similar_apparels(base_apparel)
    base_apparel.similars.each do |apparel|
      apparel.apparel_ratings.each do |rating|
        base_rating = base_apparel.apparel_ratings.find_by(user: rating.user)
        if !base_rating || rating.created_at > base_rating.created_at
          base_rating.destroy! if base_rating
          rating.update(apparel_id: base_apparel.id)
          # if base_rating
          #   puts "UPDATING RATING: #{base_apparel.id}|#{apparel.id} => #{base_rating.id}|#{rating.id}"
          # else
          #   puts "INSERT RATING: #{base_apparel.id}|#{apparel.id} => #{rating.id}"
          # end
        end
      end

      apparel.chat_apparels.each do |chat_apparel|
        base_chat_apparel = base_apparel.chat_apparels.find_by(chat: chat_apparel.chat)
        if !base_chat_apparel || chat_apparel.created_at > base_chat_apparel.created_at
          base_chat_apparel.destroy! if base_chat_apparel
          chat_apparel.update(apparel_id: base_apparel.id)
          # if base_chat_apparel
          #   puts "UPDATING RATING: #{base_apparel.id}|#{apparel.id} => #{base_chat_apparel.id}|#{chat_apparel.id}"
          # else
          #   puts "INSERT RATING: #{base_apparel.id}|#{apparel.id} => #{chat_apparel.id}"
          # end
        end
      end

      # puts "REMOVING APPAREL: #{base_apparel.id}|#{apparel.id}"
      apparel.reload
      apparel.destroy!
    end
  end

  def merge_apparels
    checked = []
    apparel = self.apparels.where.not(id: checked).first
    while apparel
      checked.push(apparel.id)

      merge_similar_apparels(apparel)

      apparel = self.apparels.where.not(id: checked).first
    end
  end

  protected
    def set_file(new_file)
      self.image = new_file
    end
end
