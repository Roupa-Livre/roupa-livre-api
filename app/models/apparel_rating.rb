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

class ApparelRating < ActiveRecord::Base
  belongs_to :apparel
  belongs_to :user

  after_create :check_or_create_chat

  def linked_chat
    owner_user = self.user
    liked_user = self.apparel.user
    
    linked_chat = Chat.active_by_user(user1, user2)
    linked_chat
  end

  protected
    def check_or_create_chat
      if self.liked 
        owner_user = self.user
        liked_user = self.apparel.user

        liked_user_reverse_liked_ratings = liked_user.apparel_ratings.where(apparel: owner_user.apparels, liked: true)
        if liked_user_reverse_liked_ratings.length > 0
          Chat.find_or_create_chat(owner_user, liked_user)
        end
      end
    end
end
