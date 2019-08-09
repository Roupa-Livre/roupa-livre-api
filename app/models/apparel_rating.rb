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
#  deleted_at :datetime
#

class ApparelRating < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :apparel
  belongs_to :user

  validates_presence_of :user, :apparel
  validates_uniqueness_of :user, :scope => :apparel

  after_create :check_or_create_chat

  def linked_chat
    owner_user = self.user
    liked_user = self.apparel.user
    
    linked_chat = Chat.active_by_user(owner_user, liked_user)
    linked_chat
  end

  protected
    def check_or_create_chat
      if self.liked 
        owner_user = self.user
        liked_user = self.apparel.user

        liked_user_reverse_liked_ratings = liked_user.apparel_ratings.where(apparel: owner_user.apparels, liked: true)
        if liked_user_reverse_liked_ratings.length > 0
          Chat.find_or_create_chat(owner_user, liked_user, [self], liked_user_reverse_liked_ratings.to_a)
        end
      end
    end
end
