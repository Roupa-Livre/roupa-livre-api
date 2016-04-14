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

class Apparel < ActiveRecord::Base
  belongs_to :user
  
  has_many :apparel_images, dependent: :destroy
  has_many :apparel_tags, dependent: :destroy
end
