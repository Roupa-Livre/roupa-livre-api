# == Schema Information
#
# Table name: apparel_ratings
#
#  id         :integer          not null, primary key
#  apparel_id :integer          not null
#  user_id    :integer          not null
#  liked      :boolean          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ApparelRatingSerializer < ActiveModel::Serializer
  attributes :id, :apparel_id, :user_id, :liked

  def attributes(*args)
    data = super
    data[:chat] = instance_options[:chat] if instance_options[:chat] && instance_options[:chat] != nil
    data
  end
end
