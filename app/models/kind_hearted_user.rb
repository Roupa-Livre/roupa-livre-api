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

class KindHeartedUser < User
  before_save :skip_confirmation!
  
  mount_uploader :image, UserImageUploader
  validates :image, allow_blank: true, file_size: { maximum: 3.megabytes.to_i,  message: "O arquivo enviado é muito grande. Tamanho máximo 3 MB."}

  has_many :apparels, :foreign_key => "user_id", dependent: :destroy
  accepts_nested_attributes_for :apparels, :allow_destroy => true

  has_many :apparel_ratings, :foreign_key => "user_id", dependent: :destroy
  accepts_nested_attributes_for :apparel_ratings, :allow_destroy => true

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
end
