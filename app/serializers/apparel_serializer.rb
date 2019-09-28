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

class ApparelSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :description, :size_info, :gender, :age_info, :rating
  attributes :likes, :deslikes, :matches, :last_month_likes, :last_month_deslikes, :last_month_matches

  has_many :apparel_tags, serializer: ApparelTagSerializer
  has_many :apparel_images
  has_one :apparel_property, serializer: ApparelPropertySerializer

  belongs_to :user

  def attributes(*args)
    data = super
    data[:distance] = current_user.km_from_user(object.user) if current_user && current_user.id != object.user_id
    data
  end

  def rating
    object.apparel_ratings.where(user: current_user).first
  end
end
