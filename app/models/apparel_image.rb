# == Schema Information
#
# Table name: apparel_images
#
#  id         :integer          not null, primary key
#  apparel_id :integer          not null
#  file       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sort_order :integer
#  deleted_at :datetime
#

class ApparelImage < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :apparel

  mount_uploader :file, ApparelImageUploader
  validates :file, allow_blank: false, file_size: { maximum: 3.megabytes.to_i,  message: "O arquivo enviado é muito grande. Tamanho máximo 3 MB."}
end
