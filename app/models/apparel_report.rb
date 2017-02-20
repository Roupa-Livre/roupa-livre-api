# == Schema Information
#
# Table name: apparel_reports
#
#  id         :integer          not null, primary key
#  apparel_id :integer
#  user_id    :integer
#  number     :string
#  reason     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#

class ApparelReport < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :apparel
  belongs_to :user

  after_create :send_mail

  def send_mail
    ApparelMailer.report(self.id).deliver
  end
end
