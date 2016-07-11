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
#

class ApparelSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :description, :size_info, :gender, :age_info

  has_many :apparel_tags
  has_many :apparel_images

  belongs_to :user

  def attributes(*args)
    data = super
    data[:distance] = current_user.km_from_user(object.user) if current_user && current_user.id != object.user_id
    data
  end
end
