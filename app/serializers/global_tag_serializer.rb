# == Schema Information
#
# Table name: global_tags
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  body        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class GlobalTagSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :body
end
