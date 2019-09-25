# == Schema Information
#
# Table name: global_tags
#
#  id         :integer          not null, primary key
#  name       :string
#  descrition :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class GlobalTag < ActiveRecord::Base
end
